set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']
set script-interpreter := ['bash', '-euo', 'pipefail']

templates_dir := justfile_dir() + '/kubernetes/templates'

[private]
default:
    just -l kube

[doc('Apply local Flux Kustomization')]
apply-ks ns ks:
    just kube render-local-ks "{{ ns }}" "{{ ks }}" | kubectl apply --server-side --force-conflicts --field-manager=kustomize-controller -f -

[doc('Browse a PVC')]
browse-pvc ns claim:
    kubectl run -n {{ ns }} browse-pvc-{{ claim }} -it --rm --restart=Never \
        --image=mirror.gcr.io/alpine:latest \
        --overrides='{"spec":{"containers":[{"name":"browse-pvc-{{ claim }}","image":"mirror.gcr.io/alpine:latest","stdin":true,"tty":true,"command":["/bin/sh"],"workingDir":"/mnt","volumeMounts":[{"mountPath":"/mnt","name":"data"}]}],"volumes":[{"name":"data","persistentVolumeClaim":{"claimName":"{{ claim }}"}}]}}'

[doc('Debug a node')]
[script]
debug-node node:
    trap 'kubectl delete pod -n default -l app.kubernetes.io/managed-by=kubectl-debug --field-selector spec.nodeName={{ node }} --ignore-not-found --wait=false' EXIT
    kubectl debug node/{{ node }} -n default -it --image=mirror.gcr.io/alpine:latest --profile=sysadmin

[doc('Delete local Flux Kustomization')]
delete-ks ns ks:
    just kube render-local-ks "{{ ns }}" "{{ ks }}" | kubectl delete -f -

[doc('Open a shell on a node')]
node-shell node:
    kubectl debug node/{{ node }} -n system -it --image="mirror.gcr.io/alpine:latest" --profile sysadmin
    kubectl delete pod -n system -l app.kubernetes.io/managed-by=kubectl-debug

[doc('Prune pods in Failed, Pending, Succeeded or Completed state')]
[script]
prune-pods:
    for phase in Failed Pending Succeeded Completed; do
        kubectl delete pods -A --field-selector status.phase="$phase" --ignore-not-found=true
    done

[doc('Suspend or resume VolSync')]
volsync state:
    flux -n volsync-system {{ state }} kustomization volsync
    flux -n volsync-system {{ state }} helmrelease volsync
    kubectl -n volsync-system scale deployment volsync --replicas {{ if state != "suspend" { "1" } else { "0" } }}

[doc('View a secret')]
view-secret namespace secret:
    kubectl view-secret -n {{ namespace }} {{ secret }}

[doc('Get rook-ceph toolbox password')]
rook-password:
    kubectl view-secret -n rook-ceph rook-ceph-dashboard-password -q

[doc('Create app deployment')]
[script]
create-app namespace app_name template="other" storage="true" external="false" force="false":
    branch="create-app/{{ app_name }}"
    out_dir="{{ source_directory() }}/apps/{{ namespace }}/{{ app_name }}"

    if [[ -d "$out_dir" ]] && [[ -n "$(ls -A "$out_dir")" ]] && [[ "{{ force }}" != "true" ]]; then
      just log error "App directory already exists (use force=true to override): $out_dir"
      exit 1
    fi

    local_exists=false
    remote_exists=false

    if git show-ref --verify --quiet "refs/heads/$branch"; then
      local_exists=true
    fi

    if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
      remote_exists=true
    fi

    if [[ "$local_exists" == "true" ]]; then
      just log info "Switching to existing local branch: $branch"
      git switch "$branch"
    else
      just log info "Creating local branch: $branch"
      git switch -c "$branch"
    fi

    if [[ "$remote_exists" == "false" ]]; then
      just log info "Remote branch does not exist. Pushing branch to origin: $branch"
      git push -u origin "$branch"
    else
      just log info "Remote branch already exists: origin/$branch"

      if git diff --quiet && git diff --cached --quiet; then
        just log info "No local changes detected. Continuing."
      else
        just log info "Local changes detected on branch: $branch"
      fi
    fi

    if [ ! -d "{{ source_directory() }}/{{ namespace }}" ]; then
      just log warn "Namespace directory does not exist."
      just log info "Creating: {{ source_directory() }}/{{ namespace }}"
      mkdir -p "{{ source_directory() }}/{{ namespace }}"
      just template "{{ source_directory() }}/templates/namespace.yaml.j2" > "{{ source_directory() }}/{{ namespace }}/namespace.yaml"
      just template "{{ source_directory() }}/templates/kustomization.yaml.j2" > "{{ source_directory() }}/{{ namespace }}/kustomization.yaml"
    fi

    # mkdir -p "$out_dir/app"

    while IFS= read -r tpl; do
      relpath="$(grealpath --relative-to="{{ source_directory() }}/templates/apps" "$tpl")"
      out="{{ source_directory() }}/apps/{{ namespace }}/{{ app_name }}/${relpath%.j2}"

      just log info "Rendering template $tpl to $out"

      # ensure parent dir exists for nested templates
      if [ ! -d "$(dirname "$out")" ]; then
        just log warn "Parent directory does not exist for output: $out"
        just log info "Creating directory for output: $(dirname "$out")"
        mkdir -p "$(dirname "$out")"
      fi

      just template "$tpl" \
        -D "template_type={{ template }}" \
        -D "app_name={{ app_name }}" \
        -D "namespace={{ namespace }}" \
        -D "storage={{ storage }}" \
        -D "external={{ external }}" \
        > "$out"
    done < <(fd -e j2 --absolute-path . "{{ source_directory() }}/templates/apps")

    yq -i '.resources |= ((. // []) + ["./{{ app_name }}/ks.yaml"] | unique | sort)' "{{ source_directory() }}/apps/{{ namespace }}/kustomization.yaml"
    just log info "Created app deployment at {{ source_directory() }}/apps/{{ namespace }}/{{ app_name }}"
