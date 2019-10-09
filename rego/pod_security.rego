package podsecurity

operations = {"CREATE", "UPDATE"}

maxTerminationSecondsAnnotation = "devspace.cloud/pod-max-termination-grace-period-seconds"

not_allowed = {
  "nodeName",
  "dnsConfig",
  "hostIPC",
  "hostPID",
  "hostNetwork",
  "priorityClassName",
  "priority",
  "affinity.nodeAffinity",
  "affinity.podAffinity",
  "affinity.podAntiAffinity",
  "securityContext.sysctls",
  "securityContext.supplementalGroups",
  "securityContext.seLinuxOptions",
  "activeDeadlineSeconds"
}

not_allowed_container = {
  "volumeDevices",
  "securityContext.privileged",
  "securityContext.allowPrivilegeEscalation",
  "securityContext.seLinuxOptions",
  "securityContext.capabilities",
  "securityContext.procMount"
}

missing(obj, field) = true {
  not obj[field]
}

missing(obj, field) = true {
  obj[field] == ""
}

violation[{"msg": msg}] {
  operations[input.request.operation]

  pod_security_violation[{"msg": msg}]
}

violation[{"msg": msg}] {
  operations[input.request.operation]
  
  container_security_violation[{"msg": msg, "field": "containers"}]
}

violation[{"msg": msg}] {
  operations[input.request.operation]
  
  container_security_violation[{"msg": msg, "field": "initContainers"}]
}

violation[{"msg": msg}] {
  operations[input.request.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.request.object.metadata.namespace]

  not missing(namespace.metadata.annotations, maxTerminationSecondsAnnotation)

  maxTerminationSeconds := to_number(namespace.metadata.annotations[maxTerminationSecondsAnnotation])
  maxTerminationSeconds > 0

  not missing(input.request.object.spec, "terminationGracePeriodSeconds")

  input.request.object.spec.terminationGracePeriodSeconds > maxTerminationSeconds
  msg := sprintf("spec.terminationGracePeriodSeconds is greater than the maximum allowed value (is %d, allowed %d)", [input.request.object.spec.terminationGracePeriodSeconds, maxTerminationSeconds])
}

container_security_violation[{"msg":msg, "field":field}] {
  not missing(input.request.object.spec, field)

  some i
  output := split(not_allowed_container[i], ".")
  count(output) == 1

  containers := input.request.object.spec[field][_]
  not missing(containers, output[0])
  msg := sprintf("pod.spec.%s.%s.%s is not allowed", [field, containers.name, output[0]])
}

container_security_violation[{"msg":msg, "field":field}] {
  not missing(input.request.object.spec, field)

  some i
  output := split(not_allowed_container[i], ".")
  count(output) == 2

  containers := input.request.object.spec[field][_]
  not missing(containers, output[0])
  not missing(containers[output[0]], output[1])

  msg := sprintf("pod.spec.%s.%s.%s.%s is not allowed", [field, containers.name, output[0], output[1]])
}

pod_security_violation[{"msg":msg}] {
  some i
  output := split(not_allowed[i], ".")
  count(output) == 1
  not missing(input.request.object.spec, output[0])
  msg := sprintf("pod.spec.%s is not allowed", [not_allowed[i]])
}

pod_security_violation[{"msg":msg}] {
  some i
  output := split(not_allowed[i], ".")
  count(output) == 2
  not missing(input.request.object.spec, output[0])
  not missing(input.request.object.spec[output[0]], output[1])
  msg := sprintf("pod.spec.%s.%s is not allowed", [output[0], output[1]])
}

pod_security_violation[{"msg":msg}] {
  not missing(input.request.object.spec, "schedulerName")
  input.request.object.spec.schedulerName != "default-scheduler"

  msg := "pod.spec.schedulerName is not allowed"
}

pod_security_violation[{"msg":msg}] {
  not missing(input.request.object.spec, "volumes")

  volumes := input.request.object.spec["volumes"][_]
  not missing(volumes, "emptyDir")
  not missing(volumes.emptyDir, "medium")

  msg := "pod.spec.volumes.emptyDir.medium is not allowed"
}
