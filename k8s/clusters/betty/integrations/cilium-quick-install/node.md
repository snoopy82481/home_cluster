# quick-install

Use the following command to create quick-install yaml.

```sh
helm template -f ./k8s/clusters/betty/integrations/cilium-quick-install/values.yaml cilium/cilium -n kube-system > ./k8s/clusters/betty/integrations/cilium-quick-install/quick-install.yaml
```
