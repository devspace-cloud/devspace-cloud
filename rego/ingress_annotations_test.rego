package ingressannotations

test_annotations {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test",
          "annotations": {
              "nginx.ingress.kubernetes.io/whitelist-source-range": "0.0.0.0/16",
              "not-allowed": "true",
              "not-allowed-2": "test"
          }
        }
      }
    }
  } with data.inventory as {
    "cluster": {
      "v1": {
        "Namespace": {
          "test": {
            "metadata": {
              "name": "test",
              "annotations": {
                "devspace.cloud/ignore-annotations": "false"
              }
            }
          }
        }
      }
    }
  }
}

test_annotations2 {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test",
          "annotations": {
              "not-allowed": "true",
              "nginx.ingress.kubernetes.io/whitelist-source-range": "0.0.0.0/16",
              "not-allowed-2": "test"
          }
        }
      }
    }
  } with data.inventory as {
    "cluster": {
      "v1": {
        "Namespace": {
          "test": {
            "metadata": {
              "name": "test"
            }
          }
        }
      }
    }
  }
}


test_annotations3 {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test",
          "annotations": {
              "not-allowed": "true",
              "nginx.ingress.kubernetes.io/whitelist-source-range": "0.0.0.0/16",
              "not-allowed-2": "test"
          }
        }
      }
    }
  } with data.inventory as {
    "cluster": {
      "v1": {
        "Namespace": {
          "test": {
            "metadata": {
              "name": "test",
              "annotations": {
                  "test": "test"
              }
            }
          }
        }
      }
    }
  }
}