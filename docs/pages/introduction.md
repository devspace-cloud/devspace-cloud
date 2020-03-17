---
title: What is DevSpace Cloud?
sidebar_label: Introduction
---

Securely provision Kubernetes namespaces for developers:

- **Secure Multi-Tenancy & Namespace Isolation** ensure that cluster users cannot break out of their namespaces
- **On-Demand Namespace Provisioning** allows developers to create isolated namespaces with a single command
- **>70% Cost Savings With Sleep Mode** that automatically scales down pod replicas when users are not working

## How does it work?

<img src="/cloud/img/workflow-devspace-cloud.png" />

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
- **User Management** that allows to set admins and to control who can access which cluster
- **Limit Configuration** to define limits per namespace and user (e.g. X GB RAM, Y number of namespaces etc.)
- **Visual Ingress Manager** that allows developers to easily and securely expose services with a few clicks

### Great Developer Experience

- **On-Demand Namespace Creation and Automatic Isolation** with a single command
- **Automatic kubectl Context Setup** on the developer's machine (+ automatic context updates)
- **Automatic Subdomain(s) for Every Namespace** to allow service access via ingresses
- **Single-Command Application Deployment** via DevSpace CLI (optional)
- **In-Cluster Development with Hot Reloading of Containers** via DevSpace CLI (optional)

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

<br/>
<br/>
<img src="/cloud/img/cluster-compatibility.png" />
<br/>
<br/>