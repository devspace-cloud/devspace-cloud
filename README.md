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

Make sure you enter a safe database password and a domain (e.g. devspace.my-domain.com) where DevSpace Cloud should be reachable on.

5. Create an [A DNS record](https://support.dnsimple.com/articles/a-record/) to the IP of the deployed loadbalancer. You can find out the IP address of the loadbalancer via the command:

```bash
kubectl get svc devspace-cloud-nginx-ingress-controller -n devspace-cloud
```

Use the external-ip of the load balancer for the DNS record (if the IP is pending make sure your kubernetes cluster supports [load balancers](https://kubernetes.io/docs/concepts/services-networking/#loadbalancer)).

6. After the DNS record is set, please wait shortly until the Let's Encrypt certificate for your domain could be created. On success, your DevSpace Cloud instance will be available under https://your-domain.com. Create a new user via the signup form under https://your-domain.com/signup-email. This user will have admin privileges, every other user created via this form after the first user will not be an admin user anymore.

7. In order to tell DevSpace Cli to use the just created DevSpace Cloud instance run the following command:

```bash
devspace use provider devspace.my-domain.com
```

8. You are done! You can now connect a new [cluster](https://devspace.cloud/docs/cloud/clusters/connect) to the DevSpace Cloud instance (you can connect the same cluster that you used to install DevSpace Cloud or an entirely different cluster).

## Upgrade DevSpace Cloud

1. Update the repository via the command:

```bash
git pull
```

2. Run the following command to update devspace cloud:

```bash
devspace deploy
```
