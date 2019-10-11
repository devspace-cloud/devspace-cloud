package ingresshosts

ingressHostAnnotation = "devspace.cloud/allowed-hosts"

operations = {"CREATE", "UPDATE"}

missing(obj, field) = true {
  not obj[field]
}

missing(obj, field) = true {
  obj[field] == ""
}

matches_any(str, patterns) {
  re_match(patterns[_], str)
}

hostPatterns = { patterns | 
  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]

  allowedHosts := { allowedHost | allowedHosts := split(namespace.metadata.annotations[ingressHostAnnotation], ","); allowedHost := trim(allowedHosts[_], " ") }
  replacedHosts := { allowedHost | allowedHost := replace(allowedHosts[_], ".", "\\.") }
  replacedHosts2 := replace(replacedHosts[_], "*", ".*")
    
  patterns := concat("", ["^", replacedHosts2, "$"]) 
}

violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(namespace.metadata.annotations, ingressHostAnnotation)

  ingress_hosts[{"msg":msg}]
}

ingress_hosts[{"msg":msg}] {
  not missing(input.review.object.spec, "backend")

  msg := "spec.backend is not allowed"
}

ingress_hosts[{"msg":msg}] {
  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(input.review.object.spec, "tls")

  host := input.review.object.spec.tls[_].hosts[_]
  not matches_any(host, hostPatterns)

  msg := sprintf("ingress tls host %s is not allowed. Allowed hosts: %s", [host, namespace.metadata.annotations[ingressHostAnnotation]])
}

ingress_hosts[{"msg":msg}] {
  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]

  host := input.review.object.spec.rules[_].host
  not matches_any(host, hostPatterns)

  msg := sprintf("ingress host %s is not allowed. Allowed hosts: %s", [host, namespace.metadata.annotations[ingressHostAnnotation]])
}