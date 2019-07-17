# DevSpace Cloud

## Install via DevSpace CLI

1. Clone this repository via:

```bash
git clone https://github.com/devspace-cloud/devspace-cloud.git
```

2. Make sure you have [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and the current context points to the cluster where you want to install DevSpace Cloud into. Create the `devspace-cloud` namespace via:

```bash
kubectl create ns devspace-cloud
```

3. Create a certificate, private key and kubernetes secret with the following commands:

```bash
# Create private key
openssl genrsa -out key.pem 2048

# Create certificate
openssl req -x509 -new -key key.pem -out cert.pem -subj '/CN=localhost'

# Create kubernetes secret
kubectl create secret generic devspace-auth-secret \
            --from-file=key.pem \
            --from-file=cert.pem \
            --dry-run -o yaml | kubectl -n devspace-cloud apply -f -
```

This certificate will be used for devspace cloud token creation and docker registry token creation.

4. Make sure [DevSpace CLI](https://github.com/devspace-cloud/devspace) is installed and run the following command:

```bash
devspace deploy
```

## Upgrade DevSpace Cloud

1. Update the repository via the command:

```bash
git pull
```

2. Run the following command to update devspace cloud:

```bash
devspace deploy
```
