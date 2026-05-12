set no-exit-message
set quiet
set script-interpreter := ['bash', '-euo', 'pipefail']
set shell := ['bash', '-euo', 'pipefail', '-c']

bootstrap_dir := justfile_dir() + '/bootstrap'
kubernetes_dir := justfile_dir() + '/kubernetes'
controller := `talosctl config info -o yaml | yq -e '.endpoints[0]'`
nodes := `talosctl config info -o yaml | yq -r '[.nodes[] | tostring] | join (" ")'`

[private]
default:
    just -l bootstrap

# [private]
# default: talos k8s (kubeconfig "node") wait namespaces apply-secrets crds apps kubeconfig

[confirm('Bootstrap cluster? [y|N]')]
[doc('Bootstrap a Talos & Kubernetes cluster end-to-end')]
cluster: nodes k8s (kubeconfig "node") base apps kubeconfig

[private]
[script]
nodes:
    just log info "Running stage..." "stage" "$(basename "$0")"
    for n in {{ nodes }}; do
        if ! op=$(just --yes talos apply-node "$n" --insecure 2>&1); then
            if [[ "$op" == *"certificate required"* ]]; then
                just log info "Talos already configured, skipping apply of config" "stage" "$(basename "$0")" "node" "$n"
                continue
            fi
            just log fatal "Failed to apply Talos configuration" "stage" "$(basename "$0")" "node" "$n" "output" "$op"
        fi
    done

[private]
[script]
k8s:
    just log info "Running stage..." "stage" "$0"
    until op=$(just talos bootstrap 2>&1 || true) && [[ "$op" == *"AlreadyExists"* ]]; do \
        just log info "Kubernetes bootstrap in progress. Retrying in 5 seconds..." "stage" "$0"; \
        sleep 5; \
    done

[private]
[script]
kubeconfig lb="cilium":
    just log info "Running stage..." "stage" "$0"
    if ! talosctl kubeconfig -n "{{ controller }}" -f --force-context-name main {{ justfile_dir() }}; then \
        just log fatal "Failed to fetch kubeconfig" "stage" "$0"; \
    fi
    if [[ "{{ lb }}" != "cilium" ]]; then \
        if ! kubectl config set-cluster main --server "https://{{ controller }}:6443"; then \
            just log fatal "Failed to set kubectl cluster server address" "stage" "$0"; \
        fi; \
    fi

[private]
[script]
base: ready apply-secrets
    just log info "Running stage..." "stage" "$(basename "$0")"
    if ! helmfile -f "{{ source_directory() }}/helmfile.d/crds.yaml" template -q | yq ea -e 'select(.kind == "CustomResourceDefinition")' | kubectl apply --server-side --force-conflicts -f -; then
        just log fatal "Failed to apply base crds" "stage" "$(basename "$0")"
    fi

[private]
[script]
apps:
    just log info "Running stage..." "stage" "$(basename "$0")"
    if ! helmfile -f "{{ source_directory() }}/helmfile.d/apps.yaml" sync --hide-notes; then
        just log fatal "Failed to sync helmfile" "stage" "$(basename "$0")"
    fi

# Wait until nodes register as Ready=False. They only become Ready=True once the CNI is healthy.
[private]
[script]
ready:
    just log info "Running stage..." "stage" "$(basename "$0")"
    if ! kubectl wait nodes --for=condition=Ready=True --all --timeout=10s &>/dev/null; then
        until kubectl wait nodes --for=condition=Ready=False --all --timeout=10s &>/dev/null; do
            just log info "Nodes not available, waiting for nodes to be available. Retrying in 5 seconds..." "stage" "$(basename "$0")"
            sleep 5
        done
    fi

[private]
[script]
apply-secrets:
    just log info "Running stage..." "stage" "$0"

    secrets=(
        "{{ bootstrap_dir }}/github-deploy-key.sops.yaml"
        "{{ kubernetes_dir }}/components/common/sops/cluster-secrets.sops.yaml"
        "{{ kubernetes_dir }}/components/common/sops/sops-age.sops.yaml"
    )

    for s in "${secrets[@]}"; do
        just bootstrap apply-secret "$s"
    done

[private]
[script]
apply-secret file:
    if [[ ! -f "{{ file }}" ]]; then
        just log warn "File does not exist" "file={{ file }}"
        exit 0
    fi

    resource="$(basename "{{ file }}" ".sops.yaml")"

    # Check whether secret is up-to-date
    if sops exec-file "{{ file }}" "kubectl --namespace flux-system diff --filename {}" &>/dev/null; then
        just log info "Secret resource is up-to-date" "resource=${resource}"
        exit 0
    fi

    # Apply secret
    if ! sops exec-file "{{ file }}" "kubectl --namespace flux-system apply --server-side --filename {}" &>/dev/null; then
        just log error "Failed to apply secret" "resource=${resource}"
    fi
