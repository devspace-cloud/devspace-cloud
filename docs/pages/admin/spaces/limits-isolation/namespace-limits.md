---
title: Namespace Limits
sidebar_label: Namespace Limits
---

Limits in this Fragment apply to the complete Space and are enforced through a [Resource Quota](https://kubernetes.io/docs/concepts/policy/resource-quotas/). 

## Kubernetes Resources
|Limit|Description|
|-|-|
|**Max Pods**|The max number of pods allowed in a namespace|
|**Max Services**|The max number of services allowed in a namespace|
|**Max Persistent Volumes Claims**|The max number of persistent volume claims allowed in a namespace|
|**Max Secrets**|The max number of secrets allowed in a namespace|
|**Max Config Maps**|The max number of config maps allowed in a namespace|
|**Max Ingresses**|The max number of ingresses allowed in a namespace||
|**Max Roles**|The max number of roles allowed in a namespace|
|**Max Role Bindings**|The max number of role bindings allowed in a namespace|
|**Max Service Accounts**|The max number of service accounts allowed in a namespace|

## CPU
|Limit|Description|
|-|-|
|**Max Limit CPU**|The max sum of core limits defined on all containers per namespace|
|**Max Requests CPU**|The max sum of core requests defined on all containers per namespace|

## Memory
|Limit|Description|
|-|-|
|**Max Limit Memory**|The max sum of memory limits defined on all containers per namespace|
|**Max Requests Memory**|The max sum of memory requests defined on all containers per namespace|

## Storage
|Limit|Description|
|-|-|
|**Max Requests Storage**|The max sum of all requested storage trough persistent volume claims in a namespace|
|**Max Limit Persistent Volume Claim**|The maximum limit of requested storage per persistent volume claim  
|**Min Limit Persistent Volume Claim**|The minimum limit of requested storage per persistent volume claim 
|**Max Limit Ephemeral Storage**|The max sum of [ephemeral storage](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#local-ephemeral-storage) limits defined on all containers per namespace|
|**Max Requests Ephemeral Storage**|The max sum of [ephemeral storage](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#local-ephemeral-storage) requests defined on all containers per namespace|
|**Empty Dir Storage Allowed**|If true allows pods to specify an empty dir volume (enforced by admission controller)|
|**Empty Dir Storage Default Size**|The default size of the empty dir volume if none specified (enforced by admission controller)|
|**Empty Dir Storage Max Size**|The maximum size allowed for empty dir volumes (enforced by admission controller)| 


## Advanced Options
|Limit|Description|
|-|-|
|**Enable Limit Range**|Deploys a limit range object into the space that enforces default limits and limits per container and persistent volume claim|
|**Enable Resource Quota**|Deploys a resource quota object into the space that enforces namespace limits|
|**Max Pod Container**|The maximum number of containers allowed per pod (Enforced by admission controller)|
|**Max pod termination grace period in seconds**|The maximum allowed number of seconds to wait if a pod should be terminated|
|**Use Cluster Role for Service Account**|Uses the given cluster role to create a rolebinding for the default and user service account in the space|
|**Enable Admission Controller**|Marks the namespace for the admission controller to check for certain security problems within container specifications and enforces some limits|
|**Skip Admission controller pod security checks**|If true the admission controller skips potential security issue checks on deployed pods|
|**Set Node Selector for pods**|Automatically makes sure the following node selector is set for each deployed pod (e.g. devspace.cloud/type=limited)|
|**Set Tolerations for pods**|Automatically makes sure the following tolerations are set for each deployed pod (e.g. devspace.cloud/taint=limited)|

## Custom Quotas
|Limit|Description|
|-|-|
|**Custom resourcequota limits**|Custom resource quota limits that will be appended to the `spec.hard` Fragment of the created resource quota (e.g. "count/customresource=10,count/customresource2=10")|
