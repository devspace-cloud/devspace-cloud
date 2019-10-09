package podlimits

test_max_pod_containers {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "containers": [
            {
              "name": "container-1"
            },
            {
              "name": "container-2"
            },
            {
              "name": "container-3"
            },
            {
              "name": "container-4"
            },
            {
              "name": "container-5"
            }
          ]
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
                "devspace.cloud/pod-max-containers": "4"
              }
            }
          }
        }
      }
    }
  }
}

test_min_cpu_limit {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "containers": [
            {
              "name": "container-1",
              "resources": {
                "limits": {
                  "cpu": "3"
                }
              }
            },
            {
              "name": "container-2",
              "resources": {
                "limits": {
                  "cpu": "1"
                }
              }
            },
            {
              "name": "container-3",
              "resources": {
                "limits": {
                  "cpu": "0"
                }
              }
            },
            {
              "name": "container-4"
            },
            {
              "name": "container-5",
              "resources": {
                "limits": {
                  "memory": "100M"
                }
              }
            }
          ]
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
                "devspace.cloud/container-min-cpu-limit": "0"
              }
            }
          }
        }
      }
    }
  }
}

test_min_memory_limit {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "containers": [
            {
              "name": "container-1",
              "resources": {
                "limits": {
                  "cpu": "3"
                }
              }
            },
            {
              "name": "container-2",
              "resources": {
                "limits": {
                  "cpu": "1"
                }
              }
            },
            {
              "name": "container-3",
              "resources": {
                "limits": {
                  "cpu": "0",
                  "memory": "100Ki"
                }
              }
            },
            {
              "name": "container-4"
            },
            {
              "name": "container-5",
              "resources": {
                "limits": {
                  "memory": "100M"
                }
              }
            }
          ]
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
                "devspace.cloud/container-min-memory-limit": "1Mi"
              }
            }
          }
        }
      }
    }
  }
}

test_min_es_limit {
  violation[{"msg":msg}] with input as {
    "request": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "containers": [
            {
              "name": "container-1",
              "resources": {
                "limits": {
                  "cpu": "3",
                  "ephemeral-storage": "1Gi"
                }
              }
            },
            {
              "name": "container-2",
              "resources": {
                "limits": {
                  "cpu": "1",
                  "ephemeral-storage": "0"
                }
              }
            },
            {
              "name": "container-3",
              "resources": {
                "limits": {
                  "cpu": "0",
                  "memory": "100Ki"
                }
              }
            },
            {
              "name": "container-4"
            },
            {
              "name": "container-5",
              "resources": {
                "limits": {
                  "memory": "100M",
                  "ephemeral-storage": "1Mi"
                }
              }
            }
          ]
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
                "devspace.cloud/container-min-ephemeral-storage-limit": "1Gi"
              }
            }
          }
        }
      }
    }
  }
}