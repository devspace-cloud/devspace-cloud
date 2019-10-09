package ingresshosts

test_backend {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "backend": {
            "serviceName": "test"
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
                "devspace.cloud/allowed-hosts": "test.com,test2.com"
              }
            }
          }
        }
      }
    }
  }
}

test_hosts {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "rules": {
            {
              "host": "test.test2.com"
            },
            {
              "host": "test2.com"
            }
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
                "devspace.cloud/allowed-hosts": "test.com,test2.com"
              }
            }
          }
        }
      }
    }
  }
}

test_hosts_prefixe {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "rules": {
            {
              "host": "test.test2.com"
            },
            {
              "host": "teest.test2.com"
            },
            {
              "host": "test2.com"
            }
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
                "devspace.cloud/allowed-hosts": "test.com,test2.com",
                "devspace.cloud/ingress-allowed-host-prefixes": "test* ,test1."
              }
            }
          }
        }
      }
    }
  }
  
  trace(msg)
  1 == 0
}
