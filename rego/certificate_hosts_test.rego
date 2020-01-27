package certificatehosts

test_issuer_ref {
  violation[{"msg":msg}] with input as {
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "acme": {
            "config": {

            }
          },
          "dnsNames": []
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
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "acme": {
            "config": [
              {
                "domains": ["test3.com"],
                "http01": {
                  "ingressClass": "nginx"
                }
              }
            ],
          },
          "dnsNames": [],
          "issuerRef": {
            "kind": "ClusterIssuer",
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
    "review": {
      "operation": "UPDATE",
      "object": {
        "metadata": {
          "namespace": "test"
        },
        "spec": {
          "acme": {
            "config": [
              {
                "domains": ["test.test2.com"],
                "http01": {
                  "ingressClass": "nginx"
                }
              }
            ],
          },
          "dnsNames": ["test3.com"],
          "issuerRef": {
            "kind": "ClusterIssuer",
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
                "devspace.cloud/allowed-hosts": "test.com,*.test2.com"
              }
            }
          }
        }
      }
    }
  }
}
