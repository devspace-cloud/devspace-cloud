---
title: Upgrading
sidebar_label: Upgrading
---

Upgrade to the newest version:
```bash
helm upgrade devspace-cloud -n devspace-cloud
```
Check the [release notes](https://github.com/devspace-cloud/devspace-cloud/releases) for details on how to upgrade to a specific release.  

:::warning Skip Versions
Do **<u>not</u>** skip releases with release notes containing upgrade instructions!
:::

Upgrade to a specific version:
```bash
helm upgrade devspace-cloud -n devspace-cloud --version [version]
```