#!/bin/bash

# Exit on error
set -e

# Devspace cloud namespace
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
NAMESPACE=devspace-cloud

# Check if kubectl exists
if ! command -v kubectl > /dev/null; then
  echo "'kubectl' couldn't be found. Please make sure you have 'kubectl' installed"
  exit 1
fi

# Check if devspace exists
if ! command -v devspace > /dev/null; then
  echo "'devspace' couldn't be found. Please make sure you have 'devspace' installed"
  exit 1
fi

# Verify devspace cloud is installed in context
if ! (kubectl get ns $NAMESPACE > /dev/null && kubectl get deploy devspace-manager -n $NAMESPACE > /dev/null); then
  echo "Seems like devspace-cloud isn't installed in this kubernetes context"
  exit 1
fi

# Check if we have to convert the certificate
if kubectl get secret -n $NAMESPACE -o yaml | grep 'cert.pem' > /dev/null; then
  echo ""
  echo "Converting certificate"

  # Backup secret
  kubectl get secret -n $NAMESPACE devspace-auth-secret -o yaml | grep -v "resourceVersion" > cert-backup.yaml

  echo "Backed up old certificate at cert-backup.yaml, to restore old certificate run 'kubectl delete secret -n $NAMESPACE devspace-auth-secret && kubectl apply -f cert-backup.yaml'"

  # Find out cert & key
  CERT=$(cat cert-backup.yaml | grep 'cert.pem' | grep -v 'apiVersion' | sed -E 's/.*\s*cert.pem:\s*(.*)/\1/g')
  KEY=$(cat cert-backup.yaml | grep 'key.pem' | grep -v 'apiVersion' | sed -E 's/.*\s*key.pem:\s*(.*)/\1/g')

  # Delete old secret
  kubectl delete secret -n $NAMESPACE devspace-auth-secret

  # Replace cert & key in template & apply to kubernetes
  cat $DIR/secret-template.yaml | sed -E "s/%%CRT%%/$CERT/" | sed -E "s/%%KEY%%/$KEY/" | kubectl create -n $NAMESPACE -f -

  echo "Successfully converted certificate"
  echo ""
fi

# Migrate registry config
if kubectl get configmap -n $NAMESPACE devspace-registry-config -o yaml | grep 'url: http://devspace-auth/auth/docker/events' > /dev/null; then
  echo ""
  echo "Converting registry configmap"

  # Backup configmap
  kubectl get configmap -n $NAMESPACE devspace-registry-config -o yaml | grep -v "resourceVersion" > configmap-backup.yaml

  echo "Backed up old config map at configmap-backup.yaml, to restore old config map run 'kubectl apply -f configmap-backup.yaml'"

  # Replace configmap and apply to kubernetes
  cat configmap-backup.yaml | sed -E 's#http://devspace-auth/auth/docker/events#http://devspace-auth:8080/auth/docker/events#' | kubectl apply -n $NAMESPACE -f -

  # Restart registry
  echo "Restarting registry"

  kubectl delete po -l app=devspace-docker-registry

  echo "Successfully converted registry configmap"
  echo ""
fi

cat <<EOF
Successfully removed old devspace-cloud mainplane. You can now reinstall the new version v0.3.0 with:

helm install devspace-cloud devspace-cloud --repo https://charts.devspace.sh/ \
  --namespace devspace-cloud \
  --set database.password=[DEFINE_PASSWORD_HERE] \
  --set ingress.enabled=true \
  --set ingress.tls.enabled=true \
  --set ingress.domains={devspace.my-domain.tld} \  # do NOT remove { and }
  --wait

EOF 
