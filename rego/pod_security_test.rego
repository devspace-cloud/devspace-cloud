package podsecurity

test_nodename {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "CREATE",
      "object": {
        "metadata": {},
        "spec": {
          "nodeName": "node"
        }
      }
    }
  }
}

test_nodeaffinity {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "CREATE",
      "object": {
        "metadata": {},
        "spec": {
          "affinity": {
            "nodeAffinity": {
              "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [
                  {
                    "matchExpressions": [
                      {
                        "key": "kubernetes.io/e2e-az-name",
                        "operator": "Exists"
                      }
                    ]
                  }
                ]
              }
            }
          }
        }
      }
    }
  }
}

test_container_volume_devices {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {},
        "spec": {
          "containers": [
            {
              "name": "test",
              "volumeDevices": [
                "swag"
              ]
            }
          ]
        }
      }
    }
  }
}

test_container_security {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {},
        "spec": {
          "containers": [
            {
              "name": "allowed"
            },
            {
              "name": "test",
              "securityContext": {
                "privileged": true
              }
            },
            {
              "name": "allowed2"
            }
          ]
        }
      }
    }
  }
}

test_proc_mount {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "spec": {
          "containers": [
            {
              "name": "test",
              "securityContext": {
                "procMount": "Unmasked"
              }
            }
          ]
        }
      }
    }
  }
}

test_priority {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "spec": {
          "priority": 1
        }
      }
    }
  }
}

test_init_container_security {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {},
        "spec": {
          "initContainers": [
            {
              "name": "allowed"
            },
            {
              "name": "test",
              "securityContext": {
                "privileged": true
              }
            },
            {
              "name": "allowed2"
            }
          ]
        }
      }
    }
  }
}

test_termination_grace_period {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "terminationGracePeriodSeconds": 1500
        }
      }
    }
  } with data.inventory as {
    "cluster": {
      "v1": {
        "Namespace": {
          "test1": {
            "metadata": {
              "name": "test1"
            }
          },
          "test": {
            "metadata": {
              "name": "test",
              "annotations": {
                "devspace.cloud/pod-max-termination-grace-period-seconds": "1400"
              }
            }
          }
        }
      }
    }
  }
}
