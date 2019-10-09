package pvcsecurity

operations = {"CREATE", "UPDATE"}

not_allowed = {
  "selector",
  "dataSource"
}

missing(obj, field) = true {
  not obj[field]
}

missing(obj, field) = true {
  obj[field] == ""
}

violation[{"msg": msg}] {
  operations[input.request.operation]

  pvc_security_violation[{"msg": msg}]
}

# Volume name
pvc_security_violation[{"msg":msg}] {
  input.request.operation == "CREATE"

  not missing(input.request.object.spec, "volumeName")
  msg := sprintf("pvc.spec.%s is not allowed", ["volumeName"])
}

pvc_security_violation[{"msg":msg}] {
  some i
  not missing(input.request.object.spec, not_allowed[i])
  msg := sprintf("pvc.spec.%s is not allowed", [not_allowed[i]])
}
