set positional-arguments := true
set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

root_dir := justfile_dir()
bootstrap_dir := justfile_dir() + '/bootstrap'
kubernetes_dir := justfile_dir() + '/kubernetes'
controller := `talosctl config info -o yaml | yq -e '.endpoints[0]'`
nodes := `talosctl config info -o yaml | yq -r '[.nodes[] | tostring] | join (" ")'`

[private]
default: talos k8s (kubeconfig "node") wait namespaces apply-secrets crds apps kubeconfig

[doc('Install Talos')]
talos:
    just log info "Running stage..." "stage" "$0"
    for n in {{ nodes }}; do \
        if ! op=$(just talos apply-node "$n" --extra-flags="--insecure" 2>&1); then \
            if [[ "$op" == *"certificate required"* ]]; then \
                just log info "Talos already configured, skipping apply of config" "stage" "$0" "node" "$n"; \
                continue; \
            fi; \
            just log fatal "Failed to apply Talos configuration" "stage" "$0" "node" "$n" "output" "$op"; \
        fi; \
    done

[doc('Install Kubernetes')]
k8s:
    just log info "Running stage..." "stage" "$0"
    until op=$(just talos bootstrap 2>&1 || true) && [[ "$op" == *"AlreadyExists"* ]]; do \
        just log info "Kubernetes bootstrap in progress. Retrying in 5 seconds..." "stage" "$0"; \
        sleep 5; \
    done

[doc('Fetch kubeconfig')]
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

[doc('Wait for nodes to be not-ready')]
wait:
    just log info "Running stage..." "stage" "$0"
    if ! kubectl wait nodes --for=condition=Ready=True --all --timeout=10s &>/dev/null; then \
        until kubectl wait nodes --for=condition=Ready=False --all --timeout=10s &>/dev/null; do \
            just log info "Nodes not available, waiting for nodes to be available. Retrying in 5 seconds..." "stage" "$0"; \
            sleep 5; \
        done \
    fi

[doc('Apply Kubernetes namespaces')]
namespaces:
    just log info "Running stage..." "stage" "$0"
    find "{{ kubernetes_dir }}/apps" -mindepth 1 -maxdepth 1 -type d | while IFS= read -r dir; do \
        if ! kustomize build "$dir" | yq ea -e 'select(.kind == "Namespace")' | kubectl apply --server-side --field-manager bootstrap --force-conflicts -f -; then \
            just log fatal "Failed to apply namespace" "stage" "$0" "namespace" "$(basename "$dir")"; \
        fi; \
    done

[doc('Apply Kubernetes resources')]
resources:
    just log info "Running stage..." "stage" "$0"
    if ! just template "{{ bootstrap_dir }}/resources.yaml.j2" | kubectl apply --server-side --field-manager bootstrap --force-conflicts -f -; then \
        just log fatal "Failed to apply resources" "stage" "$0"; \
    fi;

[doc('Apply Helmfile CRDs')]
crds:
    just log info "Running stage..." "stage" "$0"
    if ! helmfile -f "{{ bootstrap_dir }}/helmfile.d/00-crds.yaml" template -q | kubectl apply --server-side --field-manager bootstrap --force-conflicts -f -; then \
        just log fatal "Failed to apply crds" "stage" "$0"; \
    fi;

[doc('Apply Helmfile Apps')]
apps:
    just log info "Running stage..." "stage" "$0"
    if ! helmfile -f "{{ bootstrap_dir }}/helmfile.d/01-apps.yaml" sync --hide-notes; then \
        just log fatal "Failed to sync helmfile" "stage" "$0"; \
    fi

[doc('Apply SOPS secrets')]
apply-secrets:
    #!/usr/bin/env bash

    just log info "Running stage..." "stage" "$0"

    secrets=(
        "{{ root_dir }}/bootstrap/github-deploy-key.sops.yaml"
        "{{ root_dir }}/kubernetes/components/common/sops/cluster-secrets.sops.yaml"
        "{{ root_dir }}/kubernetes/components/common/sops/sops-age.sops.yaml"
    )

    for s in "${secrets[@]}"; do
        just bootstrap apply-secret "$s"
    done

[private]
apply-secret file:
    #!/usr/bin/env bash

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
    if sops exec-file "{{ file }}" "kubectl --namespace flux-system apply --server-side --filename {}" &>/dev/null; then
        just log info "Secret applied successfully" "resource=${resource}"
    else
        just log error "Failed to apply secret" "resource=${resource}"
        exit 1
    fi
