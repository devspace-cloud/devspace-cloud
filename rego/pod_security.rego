package podsecurity

operations = {"CREATE", "UPDATE"}

maxTerminationSecondsAnnotation = "devspace.cloud/pod-max-termination-grace-period-seconds"

not_allowed = {
  "dnsConfig",
  "hostIPC",
  "hostPID",
  "hostNetwork",
  "priorityClassName",
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
  "securityContext.capabilities"
}

missing(obj, field) = true {
  not obj[field]
}

missing(obj, field) = true {
  obj[field] == ""
}

missing(obj, field) = true {
  obj[field] == null
}

violation[{"msg":msg}] {
  operations[input.review.operation]

  pod_security_violation[{"msg": msg}]
}

violation[{"msg":msg}] {
  operations[input.review.operation]
  
  container_security_violation[{"msg": msg, "field": "containers"}]
}

violation[{"msg":msg}] {
  operations[input.review.operation]
  
  container_security_violation[{"msg": msg, "field": "initContainers"}]
}

violation[{"msg":msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]

  not missing(namespace.metadata.annotations, maxTerminationSecondsAnnotation)

  maxTerminationSeconds := to_number(namespace.metadata.annotations[maxTerminationSecondsAnnotation])
  maxTerminationSeconds > 0

  not missing(input.review.object.spec, "terminationGracePeriodSeconds")

  input.review.object.spec.terminationGracePeriodSeconds > maxTerminationSeconds
  msg := sprintf("spec.terminationGracePeriodSeconds is greater than the maximum allowed value (is %d, allowed %d)", [input.review.object.spec.terminationGracePeriodSeconds, maxTerminationSeconds])
}

container_security_violation[{"msg":msg, "field":field}] {
  not missing(input.review.object.spec, field)

  check := not_allowed_container[_]
  output := split(check, ".")
  count(output) == 1

  containers := input.review.object.spec[field][_]
  not missing(containers, output[0])
  msg := sprintf("pod.spec.%s.%s.%s is not allowed", [field, containers.name, output[0]])
}

container_security_violation[{"msg":msg, "field":field}] {
  not missing(input.review.object.spec, field)

  check := not_allowed_container[_]
  output := split(check, ".")
  count(output) == 2

  containers := input.review.object.spec[field][_]
  not missing(containers, output[0])
  not missing(containers[output[0]], output[1])

  msg := sprintf("pod.spec.%s.%s.%s.%s is not allowed", [field, containers.name, output[0], output[1]])
}

container_security_violation[{"msg":msg, "field":field}] {
  not missing(input.review.object.spec, field)

  container := input.review.object.spec[field][_]
  not missing(container, "securityContext")
  not missing(container.securityContext, "procMount")

  container.securityContext.procMount != "Default"

  msg := sprintf("pod.spec.%s.%s.securityContext.procMount is not allowed", [field, container.name])
}

pod_security_violation[{"msg":msg}] {
  input.review.operation == "CREATE"

  not missing(input.review.object.spec, "nodeName")
  msg := sprintf("pod.spec.%s is not allowed", ["nodeName"])
}

pod_security_violation[{"msg":msg}] {
  check := not_allowed[_]
  output := split(check, ".")
  count(output) == 1
  not missing(input.review.object.spec, output[0])
  msg := sprintf("pod.spec.%s is not allowed", [output[0]])
}

pod_security_violation[{"msg":msg}] {
  check := not_allowed[_]
  output := split(check, ".")
  count(output) == 2
  not missing(input.review.object.spec, output[0])
  not missing(input.review.object.spec[output[0]], output[1])
  msg := sprintf("pod.spec.%s.%s is not allowed", [output[0], output[1]])
}

pod_security_violation[{"msg":msg}] {
  not missing(input.review.object.spec, "schedulerName")
  input.review.object.spec.schedulerName != "default-scheduler"

  msg := "pod.spec.schedulerName is not allowed"
}

pod_security_violation[{"msg":msg}] {
  not missing(input.review.object.spec, "priority")
  input.review.object.spec.priority != 0

  msg := "pod.spec.priority is not allowed"
}

pod_security_violation[{"msg":msg}] {
  not missing(input.review.object.spec, "volumes")

  volumes := input.review.object.spec["volumes"][_]
  not missing(volumes, "emptyDir")
  not missing(volumes.emptyDir, "medium")

  msg := "pod.spec.volumes.emptyDir.medium is not allowed"
}
