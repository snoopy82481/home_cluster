#!/usr/bin/env bash
# shellcheck disable=2312

git_repo_url="git@github.com:prometheus-operator/prometheus-operator.git"
yaml_dir="example/prometheus-operator-crd"

pushd integrations >/dev/null 2>&1 || exit 1

tmp_dir=$(mktemp -d)
git clone "$git_repo_url" "$tmp_dir"

cd "$tmp_dir/$yaml_dir"

for file in *.yaml; do
    kubectl apply -f "$file"
done

rm -rf "$tmp_dir"

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
