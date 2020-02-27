<img src="static/img/logo-devspace-cloud.svg">

### **[Website](https://devspace.cloud/products/devspace-cloud)** • **[Quickstart](#install-devspace-cloud)** • **[Architecture](#architecture)** • **[Documentation](https://devspace.cloud/cloud/docs/introduction)** • **[Blog](https://devspace.cloud/blog)** • **[Slack](https://devspace.cloud/slack)** • **[Twitter](https://twitter.com/devspace)**

![Latest Release](https://img.shields.io/github/v/release/devspace-cloud/devspace-cloud?style=for-the-badge&label=Latest%20Release&color=%23007ec6)

### Securely provision Kubernetes namespaces for developers

- **Secure Multi-Tenancy & Namespace Isolation** ensure that cluster users cannot break out of their namespaces
- **On-Demand Namespace Provisioning** allows developers to create isolated namespaces with a single command
- **>70% Cost Savings With Sleep Mode** that automatically scales down pod replicas when users are not working

<br>

[![DevSpace Cloud Intro](static/img/devspace-cloud-readme-intro.gif)](https://devspace.cloud/products/devspace-cloud)

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

## [Install DevSpace Cloud](https://devspace.cloud/cloud/docs/introduction)
Learn more in the **[DevSpace Cloud Documentation](https://devspace.cloud/cloud/docs/introduction)**
