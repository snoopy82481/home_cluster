# quick-install

Use the following command to create quick-install yaml.

```sh
helm template -f kubernetes/apps/kube-system/cilium/install/values.yaml cilium/cilium -n kube-system > kubernetes/apps/kube-system/cilium/install/quick-install_1.yaml
```
