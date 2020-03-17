---
title: Container Limits
sidebar_label: Container Limits
---


## CPU
|Limit|Description|
|-|-|
|**Max Container CPU**|Maximum amount of cores allowed per container|
|**Min Container CPU**|The minimum limits allowed for container cpu (Enforced by admission controller)|
|**Min Requests Container CPU**|The minimum requests allowed for container cpu|
|**Default Requests CPU**|The default cpu requests to use if no requests are defined for the container|
|**Default Limit CPU**|The default cpu limits to use if no limits are defined for the container|

## Memory
|Limit|Description|
|-|-|
|**Max Container Memory**|Maxmimum amount of memory allowed per container|
|**Min Container Memory**|The minimum limits allowed for container memory (Enforced by admission controller)|
|**Min Requests Container Memory**|The minimum requests allowed for container memory|
|**Default Requests Memory**|The default memory requests to use if no requests are defined for the container|
|**Default Limit Memory**|The default memory limits to use if no limits are defined for the container|

## Storage
|Limit|Description|
|-|-|
|**Max Container Ephemeral Storage**|Maxmimum amount of ephemeral storage allowed per container|
|**Min Container Ephemeral Storage**|The minimum limits allowed for ephemeral storage (Enforced by admission controller)|
|**Min Requests Container Ephemeral Storage**|The minimum requests allowed for ephemeral Storage|
|**Default Requests Ephemeral Storage**|The default [ephemeral storage](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#local-ephemeral-storage) requests to use if no requests are defined for the container|
|**Default Limit Ephemeral Storage**|The default [ephemeral storage](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#local-ephemeral-storage) limits to use if no limits are defined for the container|