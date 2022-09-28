# quick-install

Use the following command to create quick-install yaml.

```sh
helm template -f ./k8s/clusters/namespace/kube-system/cilium/cilium-quick-install/values.yaml cilium/cilium -n kube-system > ./k8s/clusters/namespace/kube-system/cilium/cilium-quick-install/quick-install.yaml
```
