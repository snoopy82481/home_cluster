set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

nodes := `talosctl config info -o yaml | yq -r '[.nodes[] | tostring] | join(",")'`
talos_version := `yq .talosVersion "talenv.yaml"`
kubernetes_version := `yq .kubernetesVersion "talenv.yaml"`
proxmox_user := "root"
proxmox_host := "proxmox"
proxmox_iso_dir := "/var/lib/vz/template/iso"
ssh_opts := "-o BatchMode=yes -o ConnectTimeout=5"

[private]
default:
    just -l talos

[script]
[private]
_download_local_atomic url out_path:
  tmp="{{ out_path }}.part"
  fname="$(basename "{{ out_path }}")"
  gum spin --title "Downloading ${fname} ..." -- \
    curl -fL --remove-on-error --retry 5 --retry-delay 5 --retry-all-errors --progress-bar \
      -o "${tmp}" "{{ url }}"
  mv -f "${tmp}" "{{ out_path }}"
  sha256sum "{{ out_path }}" | awk '{print $1}'

[script]
[private]
_push_remote_atomic local_path remote_path:
  fname="$(basename "{{ local_path }}")"
  gum spin --title "Uploading ${fname} to {{ proxmox_host }} ..." -- \
    scp {{ ssh_opts }} "{{ local_path }}" {{ proxmox_user }}@{{ proxmox_host }}:"{{ remote_path }}"
  ssh {{ ssh_opts }} {{ proxmox_user }}@{{ proxmox_host }} "sha256sum '{{ remote_path }}'" | awk '{print $1}'

[script]
[private]
_sync_image_atomic fname url:
  fname="{{ fname }}"
  url="{{ url }}"
  local_path="{{ source_directory() }}/{{ fname }}"
  remote_path="{{ proxmox_iso_dir }}/{{ fname }}"
  local_sha="$(just talos _download_local_atomic "${url}" "${local_path}")"
  remote_sha="$(just talos _push_remote_atomic "${local_path}" "${remote_path}")"
  if [[ "${local_sha}" != "${remote_sha}" ]]; then
    just log error "Checksum mismatch for {{ fname }}" "local" "${local_sha}" "remote" "${remote_sha}"
    exit 2
  fi
  just log info "Uploaded + verified Talos ISO" "file" "{{ fname }}" "checksum" "${remote_sha}" "host" "{{ proxmox_host }}"

[doc('Apply Talos config to a node')]
apply-node node *args:
    talhelper gencommand apply -n "{{ node }}" {{ args }} | bash

[doc('Bootstrap the Talos cluster')]
bootstrap:
    talhelper gencommand bootstrap | bash

[script]
[doc('Download Talos machine image (atomic: download -> checksum -> push -> verify)')]
download-image version schematic secureboot="true":
  suffix=""
  path="metal-amd64.iso"
  case "{{ secureboot }}" in
    true|1|yes|y|sb)
      suffix="-secureboot"
      path="metal-amd64-secureboot.iso"
      ;;
    false|0|no|n|nsb)
      suffix=""
      path="metal-amd64.iso"
      ;;
    *)
      just log error "secureboot must be true/false (or 1/0, yes/no, sb/nsb)" "value" "{{ secureboot }}"
      exit 2
      ;;
  esac
  short="{{ replace_regex(schematic, '^(.{8}).*', '$1') }}"
  fname="talos-{{ version }}-${short}${suffix}.iso"
  url="https://factory.talos.dev/image/{{ schematic }}/{{ version }}/${path}"
  just talos _sync_image_atomic "${fname}" "${url}"
  gum spin --spinner dot --title "Remove local ISO: ${fname}" -- \
    rm -f "{{ source_directory() }}/${fname}"
  just log info "Removed local Talos iso ${fname}"

[script]
[doc("Remove old Talos machine images (local + proxmox)")]
remove-image:
  shopt -s nullglob
  files=({{ source_directory() }}/*.iso)
  if (( ${#files[@]} == 0 )); then
    mapfile -t files < <(
      ssh {{ ssh_opts }} {{ proxmox_user }}@{{ proxmox_host }} \
        "find '{{ proxmox_iso_dir }}' -maxdepth 1 -type f -name 'talos-*.iso' -printf '%f\n'"
    )
    if (( ${#files[@]} == 0 )); then
      just log error "No Talos ISO found locally or on {{ proxmox_host }}"
      exit 0
    fi
    for fname in "${files[@]}"; do
      gum spin --spinner dot --title "Deleting remote ISO on {{ proxmox_host }}: ${fname}" -- \
        ssh {{ ssh_opts }} {{ proxmox_user }}@{{ proxmox_host }} "rm -f '{{ proxmox_iso_dir }}/${fname}'"
      just log info "Removed Talos iso ${fname}"
    done
    exit 0
  fi
  for iso in "${files[@]}"; do
    fname="$(basename "$iso")"
    gum spin --spinner dot --title "Deleting local ISO: ${fname}" -- rm -f "$iso"
    gum spin --spinner dot --title "Deleting remote ISO on {{ proxmox_host }}: ${fname}" -- \
      ssh {{ ssh_opts }} {{ proxmox_user }}@{{ proxmox_host }} "rm -f '{{ proxmox_iso_dir }}/${fname}'"
    just log info "Removed Talos iso ${fname}"
  done

[doc('Update Talos machine image from version + schematic (remove old images, then download new one)')]
update-image version schematic secureboot="true":
    just talos remove-image
    just talos download-image "{{ version }}" "{{ schematic }}" "{{ secureboot }}"
    just infra proxmox-init
    just infra proxmox-plan
    just infra proxmox-apply

[confirm('Reboot node ' + node + ' [y|N] ?')]
[doc('Reboot a node')]
reboot-node node:
  talosctl -n {{ node }} reboot -m powercycle

[confirm('Reboot all nodes in the cluster [y|N] ?')]
[doc('Reboot all nodes in the cluster')]
reboot-all:
  talosctl reboot -m powercycle -n {{ nodes }}

[doc('Render Talos config for a node')]
[script]
render-config node:
    export CONTROLPLANE="$(just talos machine-controller {{ node }})"
    export SCHEMATIC="$(just talos schematic-id)"
    talosctl machineconfig patch <(just template "{{ source_directory() }}/machineconfig.yaml.j2") \
        -p @<(just template "{{ source_directory() }}/nodes/{{ node }}.yaml.j2")

[confirm('Reset node ' + node + ' [y|N] ?')]
[doc('Reset a node')]
reset-node node:
    talosctl -n "{{ node }}" reset --reboot --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --graceful=false --wait=false

[confirm('Shutdown node ' + node + ' [y|N] ?')]
[doc('Shutdown a node')]
shutdown-node node *args:
    talosctl -n "{{ node }}" shutdown --force {{ args }}

[confirm('Shutdown all nodes in the cluster [y|N] ?')]
[doc('Shutdown all nodes in the cluster')]
shutdown-all *args:
    talosctl -n "{{ nodes }}" shutdown --force {{ args }}

[confirm('Upgrade Kubernetes to ' + version + ' [y|N] ?')]
[doc('Upgrade Kubernetes version on the cluster')]
upgrade-k8s version=kubernetes_version:
    talosctl -n "$(talosctl config info -o yaml | yq -e '.endpoints[0]')" upgrade-k8s --to {{ version }}

[confirm('Upgrade node ' + node + ' [y|N] ?')]
[doc('Upgrade Talos version on a node')]
upgrade-node node:
    export schematic="$(just talos schematic-id)"; \
    talosctl -n "{{ node }}" upgrade -i "factory.talos.dev/installer-secureboot/${schematic}:{{ talos_version }}" -m powercycle --timeout=10m

[doc('Upgrade all nodes in the cluster')]
upgrade-all:
    talhelper gencommand upgrade --extra-flags "--timeout=10m" | bash

[private]
schematic-id:
    curl -sX POST --data-binary @<(just template "{{ source_directory() }}/schematic.yaml.j2") "https://factory.talos.dev/schematics" | jq -r '.id'

[private]
machine-controller node:
    just template "{{ source_directory() }}/nodes/{{ node }}.yaml.j2" | yq -e 'select(.machine) | (.machine.type == "controlplane") // ""'

[private]
machine-image:
    just template "{{ source_directory() }}/machineconfig.yaml.j2" | yq -e 'select(.machine) | .machine.install.image'
