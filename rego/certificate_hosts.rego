package certificatehosts

ingressHostAnnotation = "devspace.cloud/allowed-hosts"

operations = {"CREATE", "UPDATE"}

missing(obj, field) = true {
  not obj[field]
}

missing(obj, field) = true {
  obj[field] == ""
}

missing(obj, field) = true {
  obj[field] == null
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
  namespace.metadata.annotations[ingressHostAnnotation] == ""

  msg := "No certificate hosts allowed"
}

violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(namespace.metadata.annotations, ingressHostAnnotation)

  certificate_hosts[{"msg":msg}]
}

certificate_hosts[{"msg":msg}] {
  missing(input.review.object.spec, "dnsNames")

  msg := "spec.dnsNames must be defined"
}

certificate_hosts[{"msg":msg}] {
  missing(input.review.object.spec, "issuerRef")

  msg := "spec.issuerRef must be defined"
}

certificate_hosts[{"msg":msg}] {
  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]

  host := input.review.object.spec.dnsNames[_]
  not matches_any(host, hostPatterns)

  msg := sprintf("certificate dns name %s is not allowed. Allowed dns names: %s", [host, namespace.metadata.annotations[ingressHostAnnotation]])
}

certificate_hosts[{"msg":msg}] {
  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]

  host := input.review.object.spec.acme.config[_].domains[_]
  not matches_any(host, hostPatterns)

  msg := sprintf("certificate domain %s is not allowed. Allowed domains: %s", [host, namespace.metadata.annotations[ingressHostAnnotation]])
}