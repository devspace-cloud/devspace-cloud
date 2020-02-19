---
title: Connect Clusters
sidebar_label: 2. Connect Clusters
---

Connect a new Kubernetes cluster to DevSpace Cloud using:
```bash
devspace connect cluster
```

DevSpace will ask you to choose the kube-context of the cluster you want to connect.

<br/>

:::note Admin access required
To connect a cluster, you need admin access to the cluster. If running all the following commands return `yes`, you are most likely admin:
```bash
kubectl auth can-i "*" "*" --all-namespaces
kubectl auth can-i "*" namespace
kubectl auth can-i "*" clusterrole
kubectl auth can-i "*" crd
```
:::

:::warning Private IP Addresses
If you are using the SaaS edition of DevSpace Cloud, the API server of the cluster you want to connect must be available on a public IP address (or domain). If your cluster is only available on a private IP address, you must use the on-premise edition. **Most localhost clusters (e.g. Docker Kubernetes, Minikube) use private IP addresses.**
:::
