---
title: Team Registry
sidebar_label: Team Registry
---

To make it easier for your team to share images, DevSpace Cloud provides a private Docker registry for every team. Each team registry allows all team members to push and pull images to private repositories. 

:::note Images
Images in a team registry have the following format:
```bash
[dscr.io]/[team-name]/[image-name]:[image-tag]
```
:::

<figure class="frame">
  <img src="/img/docs/cloud/ui-team-registry.gif" alt="Use Team Registry" />
  <figcaption>DevSpace Cloud UI - Use Team Registry</figcaption>
</figure>

## Authentication
The authentication credentials for the team registry are automatically generated and fully managed by the CLI. That means the CLI will automatically retrieve and securely store your credentials when you login to DevSpace Cloud via:
```bash
devspace login
```

:::warning Permissions
Every team member has full access to the shared team registry and can pull/push Docker images using this registry.
:::

## Push with Docker
If you have Docker installed, your credentials for dscr.io will be securely stored using the Docker credentials store. This allows you to also manually push and pull images to/from dscr.io using the familiar Docker commands:
```bash
docker build -t dscr.io/myteam/image:v1 .
docker push dscr.io/myteam/image:v1
```
The commands shown above would, for example, build a Docker image with your local Docker daemon, tag it as `dscr.io/myteam/image:v1` and push it to dscr.io afterwards. 

