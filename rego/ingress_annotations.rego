package ingressannotations

ingressIgnoreAnnotations = "devspace.cloud/ignore-annotations"

allowedNginxAnnotations = {
  "nginx.ingress.kubernetes.io/app-root",
	"nginx.ingress.kubernetes.io/backend-protocol",
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
  "nginx.ingress.kubernetes.io/force-ssl-redirect",
}

notAllowedAnnotationsRegex = {
  "^.*custom\\.nginx\\.org\\/.*$",
  "^.*nginx\\.org\\/.*$",
  "^.*nginx\\.com\\/.*$",
  "^ingress\\.kubernetes\\.io\\/.*$",
  "^.*gcp\\.kubernetes\\.io\\/.*$",
  "^.*alpha\\.kubernetes\\.io\\/.*$",
  "^.*beta\\.kubernetes\\.io\\/.*$",
  "^.*google\\.cloud\\/.*$",
  "^.*cert\\-manager\\.io\\/.*$",
}

notAllowedAnnotations = {
  "kubernetes.io/ingress.global-static-ip-name",
}

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
  notAllowed := {annotation | input.review.object.metadata.annotations[annotation]; re_match(notAllowedAnnotationsRegex[_], annotation) }
  count(notAllowed) > 0

  msg := sprintf("Ingress Annotations are not allowed %s", [notAllowed])
}

check[{"msg":msg}] {
  not missing(input.review.object.metadata, "annotations")
  annotations := {annotation | input.review.object.metadata.annotations[annotation]}

  notAllowed := annotations & notAllowedAnnotations
  count(notAllowed) > 0

  msg := sprintf("Ingress Annotations are not allowed %s", [notAllowed])
}

check[{"msg":msg}] {
  not missing(input.review.object.metadata, "annotations")
  annotations := {annotation | input.review.object.metadata.annotations[annotation]; startswith(annotation, "nginx.ingress.kubernetes.io")}

  notAllowed := annotations - allowedNginxAnnotations
  count(notAllowed) > 0

  msg := sprintf("Ingress Annotations are not allowed: %v", [notAllowed])
}
