package ingressannotations

ingressIgnoreAnnotations = "devspace.cloud/ignore-annotations"

allowedAnnotations = {
  "kubernetes.io/ingress.class",
  "nginx.ingress.kubernetes.io/whitelist-source-range",
  "nginx.ingress.kubernetes.io/enable-cors",
  "nginx.ingress.kubernetes.io/cors-allow-origin",
  "nginx.ingress.kubernetes.io/cors-allow-methods",
  "nginx.ingress.kubernetes.io/cors-allow-headers",
  "nginx.ingress.kubernetes.io/cors-allow-credentials",
  "nginx.ingress.kubernetes.io/default-backend",
  "nginx.ingress.kubernetes.io/rewrite-target",
  "nginx.ingress.kubernetes.io/ssl-redirect",
  "nginx.ingress.kubernetes.io/ssl-passthrough",
}

operations = {"CREATE", "UPDATE"}

missing(obj, field) = true {
  not obj[field]
}

missing(obj, field) = true {
  obj[field] == ""
}

violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  missing(namespace.metadata, "annotations")

  check[{"msg":msg}]
}

violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  missing(namespace.metadata.annotations, ingressIgnoreAnnotations)

  check[{"msg":msg}]
}

violation[{"msg": msg}] {
  operations[input.review.operation]

  namespace := data.inventory.cluster.v1.Namespace[input.review.object.metadata.namespace]
  not missing(namespace.metadata.annotations, ingressIgnoreAnnotations)
  namespace.metadata.annotations[ingressIgnoreAnnotations] != "true"

  check[{"msg":msg}]
}

check[{"msg":msg}] {
  not missing(input.review.object.metadata, "annotations")
  annotations := {annotation | input.review.object.metadata.annotations[annotation]}

  notAllowed := annotations - allowedAnnotations
  count(notAllowed) > 0

  msg := sprintf("Annotations are not allowed: %v", [notAllowed])
}
