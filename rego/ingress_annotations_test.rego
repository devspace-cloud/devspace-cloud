package ingressannotations

test_annotations {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test",
          "annotations": {
              "custom.nginx.org/custom-test": "test",
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

  msg == "Ingress Annotations are not allowed {\"custom.nginx.org/custom-test\"}"
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
              "kubernetes.io/ingress.class": "allowed",
              "nginx.ingress.kubernetes.io/ssl-redirect": "true",
              "nginx.ingress.kubernetes.io/my-special-annotation": "0.0.0.0/16",
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

  msg == "Ingress Annotations are not allowed: {\"nginx.ingress.kubernetes.io/my-special-annotation\"}"
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
              "nginx.ingress.kubernetes.io/whitelist-source-rangeeee": "0.0.0.0/16",
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

test_annotations4 {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test",
          "annotations": {
              "ssss": "true",
              "swag": "true",
              "kubernetes.io/ingress.global-static-ip-name": "true",
              "nginx.ingress.kubernetes.io/enable-cors": "true"
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

  msg != "Ingress Annotations are not allowed {\"nginx.ingress.kubernetes.io/enable-cors\"}"
  msg == "Ingress Annotations are not allowed {\"kubernetes.io/ingress.global-static-ip-name\"}"
}
