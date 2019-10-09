package pvcsecurity

test_volumename {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "CREATE",
      "object": {
        "metadata": {},
        "spec": {
          "volumeName": "my-name"
        }
      }
    }
  }
}

test_selector {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {},
        "spec": {
          "volumeName": "my-name",
          "selector": {
              "test": "test"
          }
        }
      }
    }
  }
}