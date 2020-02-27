---
title: Network Limits & Domains
sidebar_label: Network Limits
---


|Limit|Description|
|-|-|
|**Enable Network Policy**|Deploys a network policy for the space that disallows pods in the namespace to communicate with other namespaces|
|**Use Ingress Class for ingresses**|Enforces the specified ingress class for all ingresses in the space|
|**Allow all ingress hosts in namespace**|If true allows the user to specify any host in an ingress. If false only hosts that are added in the `Domains` are allowed as hosts for ingresses. Domains can only be added by cluster admins or are added by default if a cluster default space domain is configured.|
|**Pod Egress Bandwidth**|If specified automatically enforces the annotation "kubernetes.io/egress-bandwidth" on each deployed pod|
|**Pod Ingress Bandwidth**|If specified automatically enforces the annotation "kubernetes.io/ingress-bandwidth" on each deployed pod|

