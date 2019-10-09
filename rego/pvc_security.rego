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
  operations[input.review.operation]

  pvc_security_violation[{"msg": msg}]
}

# Volume name
pvc_security_violation[{"msg":msg}] {
  input.review.operation == "CREATE"

  not missing(input.review.object.spec, "volumeName")
  msg := sprintf("pvc.spec.%s is not allowed", ["volumeName"])
}

pvc_security_violation[{"msg":msg}] {
  check := not_allowed[_]
  not missing(input.review.object.spec, check)
  msg := sprintf("pvc.spec.%s is not allowed", [check])
}
