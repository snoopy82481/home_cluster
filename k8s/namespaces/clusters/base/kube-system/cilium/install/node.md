# quick-install

Use the following command to create quick-install yaml.

```sh
helm template -f k8s/namespaces/clusters/base/kube-system/cilium/install/values.yaml cilium/cilium -n kube-system > k8s/namespaces/clusters/base/kube-system/cilium/install/quick-install_1.yaml
```
