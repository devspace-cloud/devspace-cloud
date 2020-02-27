---
title: Image Registry
sidebar_label: Image Registry
---

import Highlight from '@site/src/components/Highlight/Highlight';

**<Highlight backgroundColor="#3333dd">SaaS edition</Highlight> This page only applies to the SaaS edition.**

To make it easier for you to get started with Kubernetes, DevSpace Cloud provides a private Docker registry for you. This registry is called DevSpace Container Registry (dscr.io) and allows you to push and pull images to private repositories. 

:::note Images
Images in dscr.io have the following format:
```bash
dscr.io/[username]/[image-name]:[image-tag]
```
:::

## Authentication
The authentication credentials for dscr.io are automatically generated and fully managed by the CLI. That means the CLI will automatically retrieve and securely store your credentials when you login to DevSpace Cloud via:
```bash
devspace login
```

## Push with Docker
If you have Docker installed, your credentials for dscr.io will be securely stored using the Docker credentials store. This allows you to also manually push and pull images to/from dscr.io using the familiar Docker commands:
```bash
docker build -t dscr.io/username/image:v1 .
docker push dscr.io/username/image:v1
```
The commands shown above would, for example, build a Docker image with your local Docker daemon, tag it as `dscr.io/username/image:v1` and push it to dscr.io afterwards. 

