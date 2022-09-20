<!-- markdownlint-disable MD041 -->
<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="left" width="144px" height="144px"/>

# My home Kubernetes cluster managed by GitOps

_... managed by Flux and serviced with RenovateBot_ :robot:

![GitHub](https://img.shields.io/github/license/snoopy82481/home_cluster?style=for-the-badge)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/snoopy82481/home_cluster/Schedule:%20Renovate?color=informational&label=%20&logo=renovatebot&style=for-the-badge)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-blue?logo=pre-commit&logoColor=white&label&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/snoopy82481/home_cluster/master?style=for-the-badge)
[![Talos](https://img.shields.io/badge/OS-Talos-informational?style=for-the-badge)](https://talos.dev "Talos OS")

___

## Overview

Welcome to my home kubernetes repository.

This is a work in progress at this point and will have much more to go on in the coming weeks.

This is a complete rework of my existing cluster, that I tend to learn [Talos Linux](https://www.talos.dev) with.

The cluster is managed by [Renovatebot](https://www.whitesourcesoftware.com/free-developer-tools/renovate/) and [flux](https://toolkit.fluxcd.io/) for automation of most of the process. Except the actual deployment configurations.

___

## Thanks

A lot of my insperation came from multiple users part of the k8s-at-home community
There is a lot of code jacking from:
- @onedr0p
- @bjw-s
- @Truxnell
- @xUnholy
