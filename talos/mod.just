set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

scripts_dir := justfile_dir() + '/scripts'
talos_dir := justfile_dir() + '/talos'
controller := `talosctl config info -o yaml | yq -e '.endpoints[0]'`
nodes := `talosctl config info -o yaml | yq -r '[.nodes[] | tostring] | join(",")'`
talos_version := `yq .talosVersion "talenv.yaml"`
talos_url := `yq .talosImageURL "talenv.yaml"`
kubernetes_version := `yq .kubernetesVersion "talenv.yaml"`
proxmox_user := "root"
proxmox_host := "proxmox"
proxmox_iso_dir := "/var/lib/vz/template/iso"
ssh_opts := "-o BatchMode=yes -o ConnectTimeout=5"

[private]
default:
    just -l talos

[private]
_download_local_atomic url out_path:
  @tmp="{{ out_path }}.part"; \
  fname="$(basename "{{ out_path }}")"; \
  gum spin --title "Downloading ${fname} ..." -- \
    curl -sfL --remove-on-error --retry 5 --retry-delay 5 --retry-all-errors \
      -o "${tmp}" "{{ url }}"; \
  mv -f "${tmp}" "{{ out_path }}"; \
  sha256sum "{{ out_path }}" | awk '{print $1}'

[private]
_push_remote_atomic local_path remote_path:
  @remote_tmp="{{ remote_path }}.part"; \
  fname="$(basename "{{ local_path }}")"; \
  gum spin --title "Uploading ${fname} to {{ proxmox_host }} ..." -- \
    scp {{ ssh_opts }} "{{ local_path }}" {{ proxmox_user }}@{{ proxmox_host }}:"${remote_tmp}"; \
  gum spin --title "Finalizing ${fname} on {{ proxmox_host }} ..." -- \
    ssh {{ ssh_opts }} {{ proxmox_user }}@{{ proxmox_host }} "mv -f '${remote_tmp}' '{{ remote_path }}'"; \
  ssh {{ ssh_opts }} {{ proxmox_user }}@{{ proxmox_host }} "sha256sum '{{ remote_path }}'" | awk '{print $1}'

[private]
_sync_image_atomic fname url:
  @fname="{{ fname }}"; \
  url="{{ url }}"; \
  local_path="{{ talos_dir }}/${fname}"; \
  remote_path="{{ proxmox_iso_dir }}/${fname}"; \
  local_sha="$(just talos _download_local_atomic "${url}" "${local_path}")"; \
  remote_sha="$(just talos _push_remote_atomic "${local_path}" "${remote_path}")"; \
  if [[ "${local_sha}" != "${remote_sha}" ]]; then \
    just log error "Checksum mismatch for ${fname}" local "${local_sha}" remote "${remote_sha}"; \
    exit 2; \
  fi; \
  just log info "Uploaded + verified Talos ISO" file="${fname}" sha256="${remote_sha}" host="{{ proxmox_host }}"

[doc('Apply Talos config to a node')]
apply-node node *args:
    talhelper gencommand apply -n "{{ node }}" {{ args }} | bash

[doc('Bootstrap the Talos cluster')]
bootstrap:
    talhelper gencommand bootstrap | bash

[doc('Download Talos machine image (atomic: download -> checksum -> push -> verify)')]
download-image version schematic secureboot="true":
  @suffix=""; \
  path="metal-amd64.iso"; \
  case "{{ secureboot }}" in \
    true|1|yes|y|sb) suffix="-secureboot"; path="metal-amd64-secureboot.iso" ;; \
    false|0|no|n|nsb) suffix=""; path="metal-amd64.iso" ;; \
    *) just log error "secureboot must be true/false (or 1/0, yes/no, sb/nsb)" value "{{ secureboot }}"; exit 2 ;; \
  esac; \
  short="{{ replace_regex(schematic, '^(.{8}).*', '$1') }}"; \
  fname="talos-{{ version }}-${short}${suffix}.iso"; \
  url="https://factory.talos.dev/image/{{ schematic }}/{{ version }}/${path}"; \
  just talos _sync_image_atomic "${fname}" "${url}" \
  gum spin --spinner dot --title "Remove local ISO: ${fname}" -- \
    rm -f "{{ talos_dir }}/${fname}"; \
  just log info "Removed local Talos iso ${fname}"

[doc("Remove old Talos machine images (local + proxmox)")]
remove-image:
  @shopt -s nullglob; \
  files=({{ talos_dir }}/*.iso); \
  if (( ${#files[@]} == 0 )); then \
    just log error "No Talos ISO found in {{ talos_dir }}"; \
    exit 0; \
  fi; \
  for iso in "${files[@]}"; do \
    fname="$(basename "$iso")"; \
    gum spin --spinner dot --title "Deleting local ISO: ${fname}" -- rm -f "$iso"; \
    gum spin --spinner dot --title "Deleting remote ISO on {{ proxmox_host }}: ${fname}" -- \
      ssh {{ ssh_opts }} {{ proxmox_user }}@{{ proxmox_host }} "rm -f '{{ proxmox_iso_dir }}/${fname}'"; \
    just log info "Removed Talos iso ${fname}"; \
  done

[doc('Generate schematic ID from Talos schematic')]
gen-schematic-id:
    curl -sX POST --data-binary @<(just template "{{ talos_dir }}/schematic.yaml.j2") "https://factory.talos.dev/schematics" | jq -r '.id'

[doc('Reboot a node')]
reboot-node node:
    gum confirm "Reboot node {{ node }}?" --default="No" && \
        talosctl -n {{ node }} reboot -m powercycle || exit 0

[doc('Reboot all nodes in the cluster')]
reboot-all:
    gum confirm "Reboot all nodes?" --default="No" && \
        talosctl reboot -m powercycle -n {{ nodes }} || exit 0


[doc('Render Talos config for a node')]
render-config node:
    export IS_CONTROLLER="$(just talos machine-controller {{ node }})"; \
    talosctl machineconfig patch <(just template "{{ talos_dir }}/machineconfig.yaml.j2") \
        -p @<(just template "{{ talos_dir }}/nodes/{{ node }}.yaml.j2")

[doc('Reset a node')]
reset-node node:
    gum confirm "Reset node {{ node }}?" --default="No" && \
        talosctl -n "{{ node }}" reset --reboot --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --graceful=false --wait=false || exit 0

[doc('Shutdown a node')]
shutdown-node node:
    gum confirm "Shutdown node {{ node }}?" --default="No" && \
        talosctl -n "{{ node }}" shutdown --force || exit 0

[doc('Shutdown all nodes in the cluster')]
shutdown-all:
    gum confirm "Shutdown all nodes?" --default="No" && \
        talosctl -n "{{ nodes }}" shutdown --force || exit 0

[doc('Upgrade Kubernetes version on the cluster')]
upgrade-k8s:
    talhelper gencommand upgrade-k8s | bash

[doc('Upgrade Talos version on a node')]
upgrade-node node:
    talhelper gencommand upgrade -n "{{ node }}" --extra-flags "--timeout=10m" | bash

[doc('Upgrade all nodes in the cluster')]
upgrade-all:
    talhelper gencommand upgrade --extra-flags "--timeout=10m" | bash

[private]
machine-controller node:
    just template "{{ talos_dir }}/nodes/{{ node }}.yaml.j2" | yq -e 'select(.machine) | (.machine.type == "controlplane") // ""'

[private]
machine-image:
    just template "{{ talos_dir }}/machineconfig.yaml.j2" | yq -e 'select(.machine) | .machine.install.image'
