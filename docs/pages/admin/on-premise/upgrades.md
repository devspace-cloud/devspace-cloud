---
title: Upgrading
sidebar_label: Upgrading
---

:::info
Upgrading DevSpace Cloud requires Helm v3 and may take up to 10 minutes.
:::

Upgrade to the newest version:
```bash
helm upgrade -n devspace-cloud devspace-cloud devspace-cloud --repo https://charts.devspace.sh/ --reuse-values --wait
```
Check the [release notes](https://github.com/devspace-cloud/devspace-cloud/releases) for details on how to upgrade to a specific release.  

:::warning Skip Versions
Do **<u>not</u>** skip releases with release notes containing upgrade instructions!
:::

Upgrade to a specific version:
```bash
helm upgrade -n devspace-cloud devspace-cloud devspace-cloud --repo https://charts.devspace.sh/ --reuse-values --wait --version [version]
```
