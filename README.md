<img src="static/img/logo-devspace-cloud.svg">

<img src="static/img/line.svg" height="1">

### **[Installation](#installation)** • **[Architecture](#architecture)** • **[Documentation](https://devspace.cloud/docs)** • **[Slack](https://devspace.cloud/slack)** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [![](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Check%20out%20%23DevSpace%20-%20it%20lets%20you%20build%20cloud-native%20applications%20faster%20and%20automate%20the%20deployment%20process%20to%20%23Kubernetes%20https%3A//github.com/devspace-cloud/devspace/%0A%23cncf%20%23cloudnative%20%23cloud%20%23docker%20%23containers) [![](https://devspace.cloud/slack/badge.svg)](http://devspace.cloud/slack)

<img src="static/img/line.svg" height="1">

### DevSpace Cloud lets you securely provision Kubernetes namespaces for developers

- **Secure Multi-Tenancy & Namespace Isolation** ensure that cluster users cannot break out of their namespaces
- **On-Demand Namespace Provisioning** allows developers to create isolated namespaces with a single command
- **>70% Cost Savings With Sleep Mode** that automatically scales down pod replicas when users are not working

<br>

[![DevSpace Demo](static/img/devspace-cloud-readme.gif)](https://youtu.be/Cu98iM0lLLE)

<p align="center">
<a href="https://youtu.be/Cu98iM0lLLE">Click here to watch the full-length video with explanations on YouTube [10min]</a><br><br> ⭐️ <strong>Do you like DevSpace Cloud? Support the project with a star</strong> ⭐️
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

## Installation

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
devspace run deploy-devspace-cloud
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
devspace use provider my-domain.com
```

8. You are done! You can now connect a new [cluster](https://devspace.cloud/docs/cloud/clusters/connect) to the DevSpace Cloud instance (you can connect the same cluster that you used to install DevSpace Cloud or an entirely different cluster).

<br>

## Upgrade DevSpace Cloud

1. Update the repository via the command:

```bash
git pull
```

2. Run the following command to update devspace cloud:

```bash
devspace run deploy-devspace-cloud
```
