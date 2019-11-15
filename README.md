<img src="static/img/logo-devspace-cloud.svg">

### **[Website](https://devspace.sh)** • **[Quickstart](#installation)** • **[Architecture](#architecture)** • **[Documentation](https://devspace.cloud/docs)** • **[Blog](https://devspace.cloud/blog)** • **[Slack](https://devspace.cloud/slack)** • **[Twitter](https://twitter.com/devspace)**

![Latest Release](https://img.shields.io/github/v/release/devspace-cloud/devspace-cloud?style=for-the-badge&label=Latest%20Release&color=%23007ec6)

### Securely provision Kubernetes namespaces for developers

- **Secure Multi-Tenancy & Namespace Isolation** ensure that cluster users cannot break out of their namespaces
- **On-Demand Namespace Provisioning** allows developers to create isolated namespaces with a single command
- **>70% Cost Savings With Sleep Mode** that automatically scales down pod replicas when users are not working

<br>

[![DevSpace Cloud Intro](static/img/devspace-cloud-readme-intro.gif)](https://youtu.be/Cu98iM0lLLE)

![DevSpace Cluster Compatibility](static/img/devspace-cluster-compatibility.png)

<br>

<p align="center">
⭐️ <strong>Do you like DevSpace? Support the project with a star</strong> ⭐️
</p>

<br>

## Contents

- [Features](#features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Upgrade](#upgrade-devspace-cloud)

<br>

## Features

DevSpace allows developer teams to work together in shared Kubernetes clusters. Simply add your team members and create isolated namespaces for different users and workloads.

### Strict Namespace Isolation

- **Automatic Service Account**: every service account is restricted by RBAC to only access its namespace
- **Automatic RBAC** (role-based access control) for every service account / namespace
- **Automatic Pod Security Policies** to ensure that users cannot break out of their pod limits
- **Automatic Network Policies** to isolate network traffic between namespaces (zero trust policy by default)
- **Automatic Resource Quotas** to limit computing and storage resources available per user and namespace
- **Automatic Limit Ranges** to automatically define resource limits for containers and pods
- **Admission Controller** to validate every API server request and to perform extensive security checks

### Admin UI for Managing Users & Permissions

- **Secure Invite Links** for adding users to teams and clusters while performing secure token exchange
- **User Management** that allows to set admins and control who can access which cluster
- **Limit Configuration** to define limits per namespace and user (e.g. X GB RAM, Y number of namespaces etc.)
- **Visual Ingress Manager** that allows developers to easily and securely expose services with a few clicks

### Great Developer Experience

- **On-Demand Namespace Creation and Automatic Isolation** with a single command
- **Automatic kubectl Context Setup** on the developer's machine (+ automatic context updates)
- **Automatic Subdomain(s) for Every Namespace** to allow service access via ingresses
- **Single-Command Application Deployment** via DevSpace CLI (optional)
- **In-Cluster Development with Hot Reloading of Containers** via DevSpace CLI (optional)

> **More info and install intructions for DevSpace CLI on: [www.github.com/devspace-cloud/devspace](https://github.com/devspace-cloud/devspace)**

### Sleep Mode for Namespaces

- **>70% Savings on Cloud Infrastructure** when cluster auto-scaling is enabled
- **Detects Namespace Inactivity** (kube context not used for X minutes)
- **Automatically Scales Down Replicas to Zero** (remembers original replica number and keeps persistent data and configuration)
- **Automatically Scales Up Replicas** when developers start working again (e.g. running a kubectl, helm etc. command)

### Ships Everything Your Team Needs

- **Automatic Ingress Controller Setup & Configuration** (optional)
- **Automatic Cert Manager Setup & Configuration** for automatic SSL certificate provisioning (optional)
- **In-Build Image Registry for Every Developer and Team** (optional)
- **Self-Service Signup for Users via Email, GitHub or LDAP** (optional)

<br>

## Architecture

![DevSpace Architecture](static/img/devspace-architecture.png)

DevSpace Cloud can either be used [as-a-Service on devspace.cloud](https://devspace.cloud) or installed as an on-premise edition (see [www.github.com/devspace-cloud/devspace-cloud](https://github.com/devspace-cloud/devspace-cloud) for instructions).

No matter which edition you use, DevSpace Cloud allows you to connect any Kubernetes cluster with just a single command using DevSpace CLI: `devspace connect cluster`

After connecting a cluster, DevSpace installs a lightweight control plane inside your cluster as well as optional comfort services (e.g. ingress controller, cert manager, container registry). With the visual admin UI of DevSpace Cloud, you can now generate invite links and send them to developers. You can set limits and permissions for every developer as well as for teams of developers.

Developers can use DevSpace CLI to create isolated namespaces on-demand using a single command: `devspace create space`

DevSpace CLI runs as a single binary tool directly on a developer's computer and ideally, developers use it straight from their terminal within their favorite IDE. DevSpace CLI per-se does not require a server-side component as it communicates directly to the connected Kubernetes clusters using the kubectl context. However, using DevSpace Cloud in combination with DevSpace CLI allows you to provision namespaces for developers on-demand while DevSpace Cloud ensures that developers are restricted to their namespaces and stay within the limits that the cluster admins configured using the admin UI.

While it is entirely possible to access the isolated namespaces directly via kubectl, helm or other tools, developers can also use DevSpace CLI to streamline the deployment process and deploy complex micro service applications with just a single command: `devspace deploy`

**More info and install intructions for DevSpace CLI on: [www.github.com/devspace-cloud/devspace](https://github.com/devspace-cloud/devspace)**

<br>

## Install DevSpace Cloud
You can install DevSpace Cloud to any Kubernetes cluster. You can even install it to local clusters such as minikube or Docker Desktop Kubernetes to test it out.

<br>

### 1. Clone Repository
```bash
git clone https://github.com/devspace-cloud/devspace-cloud.git
```

<br>

### 2. Create Namespace
Make sure you have [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed and the current context points to the cluster where you want to install DevSpace Cloud into. Create the `devspace-cloud` namespace via:
```bash
kubectl create namespace devspace-cloud
```

<br>

### 3. Create Secret with Private Key & Certificate
Create a private key, a certificate and a Kubernetes secret with the following commands:
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
This secret will be used for signing tokens issued by DevSpace Cloud and should be kept private.


<br>

### 4. Install DevSpace CLI
Install DevSpace Cloud using [these install instructions](https://github.com/devspace-cloud/devspace).


<br>

### 5. Deploy DevSpace Cloud

<details>
<summary><b>Local Test Cluster (without SSL)</b>
<br>&nbsp;&nbsp;&nbsp;
<i>
for local Kubernetes clusters (minikube, kind, k3s, mikrok8s etc.)
</i>
</summary>

#### 5.1 Only for Docker Desktop Kubernetes
To ensure that your data will not be deleted when you restart your cluster, make sure your default storage class is actually provisioning persistent volumes which survive a cluster restart. 

> **If you are unsure if your storage class provisions persistent volumes which survive a cluster restart, [follow these install instructions to setup a storage class for your local cluster](https://github.com/devspace-cloud/docker-kubernetes-pv-local-storage#install).**

Then, make sure your cluster time is up-to-date either by restarting Docker or by running this command:
```bash
HOST_TIME=$(date -u +"%Y.%m.%d-%H:%M:%S");
docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined --privileged --rm -v //:/docker-vm alpine //bin/sh -c "date -s $HOST_TIME"
```
 

#### 5.2 Deploy DevSpace Cloud
```bash
devspace run deploy-devspace-cloud-no-tls
```
> Make sure you enter a safe database password.


#### 5.3 Open DevSpace Cloud
Wait until all pods are running:
```bash
kubectl get pod -w
```
Then open DevSpace Cloud in the browser on: [http://localhost/]([http://localhost/).

</details>

<br>

<details>
<summary><b>Productive Cluster with Public IP Address (with SSL)</b>
<br>&nbsp;&nbsp;&nbsp;
<i>
for any Kubernetes cluster with a public IP address (GKE, EKS, AKS etc.)
</i>
</summary>

#### 5.1 Deploy DevSpace Cloud
```bash
devspace run deploy-devspace-cloud
```
> Make sure you enter a safe database password and a domain (e.g. devspace.my-domain.tld) where DevSpace Cloud should be available on.

#### 5.2 Create DNS Record
Create an [DNS A record](https://support.dnsimple.com/articles/a-record/) pointing to the IP of the load balancer that is created when installing DevSpace Cloud. You can retrieve the IP address of this load balancer using this command:
```bash
kubectl get service devspace-cloud-nginx-ingress-controller -n devspace-cloud
```

Use the `external-ip` of the load balancer for the DNS record.

> If the `external-ip` of the service remains `pending` for a long time, make sure your Kubernetes cluster supports [load balancers](https://kubernetes.io/docs/concepts/services-networking/#loadbalancer).

#### 5.3 Open DevSpace Cloud
Wait until all pods are running:
```bash
kubectl get pod -w
```
Wait until the Let's Encrypt certificate for your DevSpace Cloud domain is provisioned:
```bash
kubectl get secret tls-devspace-cloud
```
Then open DevSpace Cloud in the browser on the domain you provided. You should see the login screen when accessing your DevSpace Cloud domain.

</details>

<br>

<details>
<summary><b>Productive Cluster without Public IP Address (without SSL)</b>
<br>&nbsp;&nbsp;&nbsp;
<i>
for clusters in private clouds, behind firewalls etc.
</i>
</summary>

#### 5.1 Deploy DevSpace Cloud
```bash
devspace run deploy-devspace-cloud-no-tls
```
> Make sure you enter a safe database password and a domain (e.g. devspace.my-domain.tld) where DevSpace Cloud should be available on.

#### 5.2 Create DNS Record
Create an [DNS A record](https://support.dnsimple.com/articles/a-record/) pointing to the IP of the load balancer that is created when installing DevSpace Cloud. You can retrieve the IP address of this load balancer using this command:
```bash
kubectl get service devspace-cloud-nginx-ingress-controller -n devspace-cloud
```

Use the `external-ip` of the load balancer for the DNS record.

> If the `external-ip` of the service remains `pending` for a long time, make sure your Kubernetes cluster supports [load balancers](https://kubernetes.io/docs/concepts/services-networking/#loadbalancer).

#### 5.3 Open DevSpace Cloud
Wait until all pods are running:
```bash
kubectl get pod -w
```

Then open DevSpace Cloud in the browser on the domain you provided. You should see the login screen when accessing your DevSpace Cloud domain.

</details>


<br>

### 6. Create Admin Account
You can now create a new user via the signup form under https://devspace.my-domain.tld/signup-email. 

> The first user you are creating will have admin privileges. Any further users created via this form will not have admin rights by default but they can be granted to additional users via the UI.


<br>

### 7. Configure CLI
In order to tell DevSpace to use your on-premise instance of DevSpace Cloud instead of the SaaS platform, run the following command:
```bash
devspace use provider devspace.my-domain.tld
```


<br>

### 8. Connect a Cluster
You can now [connect a new cluster](https://devspace.cloud/docs/cloud/clusters/connect) to your DevSpace Cloud instance using:
```bash
devspace connect cluster
```

> You can connect the same cluster that DevSpace Cloud is running in. However, this is not recommended for production use cases.


<br>

### 9. Invite Users &amp; Create Spaces
After connecing a cluster, you can add users, set resource limits and permissions for users via the UI and create isolated namespaces using:
```bash
devspace create space [name]
```

<br>

## Upgrade DevSpace Cloud

### 1. Update Cloned Repository
Getting updates is as easy as pulling the newest commits from the DevSpace Cloud git repository:
```bash
git pull
```

### 2. Run Upgrade Command
Run one of the following commands to upgrade DevSpace Cloud:

<details>
<summary><b>Local Test Cluster (without SSL)</b>
<br>&nbsp;&nbsp;&nbsp;
<i>
for local Kubernetes clusters (minikube, kind, k3s, mikrok8s etc.)
</i>
</summary>

```bash
devspace run deploy-devspace-cloud-no-tls
```

</details>

<br>

<details>
<summary><b>Productive Cluster (with SSL)</b>
<br>&nbsp;&nbsp;&nbsp;
<i>
for any other Kubernetes cluster
</i>
</summary>

```bash
devspace run deploy-devspace-cloud
```

</details>