#!/usr/bin/env bash
# shellcheck disable=2312

# Git URLs of the repositories and directories
declare -A repos_and_dirs=(
    ["git@github.com:prometheus-operator/prometheus-operator.git"]="example/prometheus-operator-crd"
    ["git@github.com:kubernetes-sigs/gateway-api.git"]="config/crd/standard"
)

# File to retrieve from the experimental directory
experimental_file="git@github.com:kubernetes-sigs/gateway-api.git:config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml"

pushd integrations >/dev/null 2>&1 || exit 1

# Loop through the repositories and directories
for repo_url in "${!repos_and_dirs[@]}"; do
    repo_dir="${repos_and_dirs[$repo_url]}"

    # Clone the Git repository to a temporary directory using SSH
    tmp_dir=$(mktemp -d)
    git clone "$repo_url" "$tmp_dir"

    # Change to the specified directory within the repository
    cd "$tmp_dir/$repo_dir"

    # Loop through the YAML files in the directory and apply them
    for file in *.yaml; do
        kubectl apply -f "$file"
    done

    # Clean up the temporary directory
    rm -rf "$tmp_dir"
done

# Retrieve the file from the experimental directory and apply it
tmp_file=$(mktemp)
git archive --remote="$experimental_file" HEAD "config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml" >"$tmp_file"
kubectl apply -f "$tmp_file"
rm "$tmp_file"

rm -rf cni/charts
envsubst <../../../../kubernetes/apps/kube-system/cilium/app/values.yaml >cni/values.yaml
kustomize build --enable-helm cni | kubectl apply -f -
rm cni/values.yaml
rm -rf cni/charts

rm -rf kubelet-csr-approver/charts
envsubst <../../../../kubernetes/apps/kube-system/kubelet-csr-approver/app/values.yaml >kubelet-csr-approver/values.yaml
kustomize build --enable-helm kubelet-csr-approver | kubectl apply -f -
rm kubelet-csr-approver/values.yaml
rm -rf kubelet-csr-approver/charts

popd >/dev/null 2>&1
