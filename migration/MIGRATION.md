# Migrate to version v0.3.0

With devspace-cloud version v0.3.0 several cluster components got updated which will require you to migrate the devspace cloud deployment. From now on, we strongly recommend to deploy devspace cloud via helm v3 instead of v2. You'll have to remove the old deployment (if deployed via helm v2) before you can install the new version.

## Convert cert secret & registry config map

In 0.3.0, instead of creating a certificate via a hook or openssl, we now rely on the [cert-manager](https://github.com/jetstack/cert-manager) to create a certificate secret for devspace cloud. However, you'll have to convert the old secret into the new format. You can use our little helper script to do this automatically via:

```
migration/migrate-0.3.0.sh
```

This command will convert the devspace cloud certificate and registry config (if deployed) automatically.

## Remove devspace cloud if deployed via helm v2

If you don't have helm v2 installed or don't know if you deployed devspace-cloud via helm v2 you can run our little helper utility:

```
devspace purge --config migration/devspace.yaml
```

## Redeploy devspace-cloud

```
# If already installed via helm 3 you can use helm upgrade instead
helm install devspace-cloud devspace-cloud --repo https://charts.devspace.sh/ \
  --namespace devspace-cloud \
  --set database.password=[DEFINE_PASSWORD_HERE] \
  --set ingress.enabled=true \
  --set ingress.tls.enabled=true \
  --set ingress.domains={devspace.my-domain.tld} \  # do NOT remove { and }
  --wait
```

## Migration of connected cluster components

It is advised to remove and reinstall the cluster components of connected clusters (however the old versions should still work fine) via the devspace cloud UI.

## Troubleshooting

If you encounter any issues during the migration process, please let us know by opening an issue at [github.com/devspace-cloud/devspace-cloud](https://github.com/devspace-cloud/devspace-cloud/issues) or directly write us in the chat at [devspace.cloud](https://devspace.cloud/)
