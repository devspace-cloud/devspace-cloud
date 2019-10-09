package podlimits

operations = {"CREATE", "UPDATE"}

maxPodContainersAnnotation = "devspace.cloud/pod-max-containers"
containerMinCPULimitAnnotation = "devspace.cloud/container-min-cpu-limit"
containerMinMemoryLimitAnnotation = "devspace.cloud/container-min-memory-limit"
containerMinEphemeralStorageLimitAnnotation = "devspace.cloud/container-min-ephemeral-storage-limit"

missing(obj, field) = true {
  not obj[field]
}

missing(obj, field) = true {
  obj[field] == ""
}

containers(obj, field) = num {
  not missing(obj, field)
  num := count(obj[field])
}

containers(obj, field) = num {
  missing(obj, field)
  num := 0
}

canonify_cpu(orig) = new {
  is_number(orig)
  new := orig * 1000
}
canonify_cpu(orig) = new {
  not is_number(orig)
  endswith(orig, "m")
  new := to_number(replace(orig, "m", ""))
}
canonify_cpu(orig) = new {
  not is_number(orig)
  not endswith(orig, "m")
  re_match("^[0-9]+$", orig)
  new := to_number(orig) * 1000
}

# 10 ** 18
mem_multiple("E") = 1000000000000000000 { true }
# 10 ** 15
mem_multiple("P") = 1000000000000000 { true }
# 10 ** 12
mem_multiple("T") = 1000000000000 { true }
# 10 ** 9
mem_multiple("G") = 1000000000 { true }
# 10 ** 6
mem_multiple("M") = 1000000 { true }
# 10 ** 3
mem_multiple("K") = 1000 { true }
# 10 ** 0
mem_multiple("") = 1 { true }
# 2 ** 10
mem_multiple("Ki") = 1024 { true }
# 2 ** 20
mem_multiple("Mi") = 1048576 { true }
# 2 ** 30
mem_multiple("Gi") = 1073741824 { true }
# 2 ** 40
mem_multiple("Ti") = 1099511627776 { true }
# 2 ** 50
mem_multiple("Pi") = 1125899906842624 { true }
# 2 ** 60
mem_multiple("Ei") = 1152921504606846976 { true }

get_suffix(mem) = suffix {
  not is_string(mem)
  suffix := ""
}
get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) > 0
  suffix := substring(mem, count(mem) - 1, -1)
  mem_multiple(suffix)
}
get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) > 1
  suffix := substring(mem, count(mem) - 2, -1)
  mem_multiple(suffix)
}
get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) > 1
  not mem_multiple(substring(mem, count(mem) - 1, -1))
  not mem_multiple(substring(mem, count(mem) - 2, -1))
  suffix := ""
}
get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) == 1
  not mem_multiple(substring(mem, count(mem) - 1, -1))
  suffix := ""
}
get_suffix(mem) = suffix {
  is_string(mem)
  count(mem) == 0
  suffix := ""
}
canonify_mem(orig) = new {
  is_number(orig)
  new := orig
}
canonify_mem(orig) = new {
  not is_number(orig)
  suffix := get_suffix(orig)
  raw := replace(orig, suffix, "")
  re_match("^[0-9]+$", raw)
  new := to_number(raw) * mem_multiple(suffix)
}

# Container amount
violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(namespace.metadata.annotations, maxPodContainersAnnotation)

  maxPodContainers := to_number(namespace.metadata.annotations[maxPodContainersAnnotation])
  maxPodContainers > 0

  containerNum := containers(input.review.object.spec, "containers") + containers(input.review.object.spec, "initContainers")
  containerNum > maxPodContainers

  msg := sprintf("maximum container amount is exceeded (is %d, allowed %d)", [containerNum, maxPodContainers])
}

# Container cpu limits
violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(namespace.metadata.annotations, containerMinCPULimitAnnotation)

  cpu_limit_violation[{"msg":msg,"annotation":containerMinCPULimitAnnotation,"resource":"cpu"}]
}

# Container memory limits
violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(namespace.metadata.annotations, containerMinMemoryLimitAnnotation)

  mem_limit_violation[{"msg":msg,"annotation":containerMinMemoryLimitAnnotation,"resource":"memory"}]
}

# Container Ephemeral storage limits
violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(namespace.metadata.annotations, containerMinEphemeralStorageLimitAnnotation)

  mem_limit_violation[{"msg":msg,"annotation":containerMinEphemeralStorageLimitAnnotation,"resource":"ephemeral-storage"}]
}

cpu_limit_violation[{"msg":msg,"annotation":annotation,"resource":resource}] {
  cpu_limit_violation_container[{"msg":msg,"field":"containers","annotation":annotation,"resource":resource}]
}

cpu_limit_violation[{"msg":msg,"annotation":annotation,"resource":resource}] {
  cpu_limit_violation_container[{"msg":msg,"field":"initContainers","annotation":annotation,"resource":resource}]
}

cpu_limit_violation_container[{"msg":msg,"field":field,"annotation":annotation,"resource":resource}] {
  not missing(input.review.object.spec, field)

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  minLimit := canonify_cpu(namespace.metadata.annotations[annotation])

  containers := input.review.object.spec[field][_]
  not missing(containers, "resources")
  not missing(containers.resources, "limits")
  not missing(containers.resources.limits, resource)

  containerLimit := canonify_cpu(containers.resources.limits[resource])
  minLimit >= containerLimit

  msg := sprintf("container %s denied, limits.%s has to be greater than %s (is %s)", [containers.name, resource, namespace.metadata.annotations[annotation], containers.resources.limits[resource]])
}

mem_limit_violation[{"msg":msg,"annotation":annotation,"resource":resource}] {
  mem_limit_violation_container[{"msg":msg,"field":"containers","annotation":annotation,"resource":resource}]
}

mem_limit_violation[{"msg":msg,"annotation":annotation,"resource":resource}] {
  mem_limit_violation_container[{"msg":msg,"field":"initContainers","annotation":annotation,"resource":resource}]
}

mem_limit_violation_container[{"msg":msg,"field":field,"annotation":annotation,"resource":resource}] {
  not missing(input.review.object.spec, field)

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  minLimit := canonify_mem(namespace.metadata.annotations[annotation])

  containers := input.review.object.spec[field][_]
  not missing(containers, "resources")
  not missing(containers.resources, "limits")
  not missing(containers.resources.limits, resource)

  containerLimit := canonify_mem(containers.resources.limits[resource])
  minLimit >= containerLimit

  msg := sprintf("container %s denied, limits.%s has to be greater than %s (is %s)", [containers.name, resource, namespace.metadata.annotations[annotation], containers.resources.limits[resource]])
}