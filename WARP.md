# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a Talos Linux-based home Kubernetes cluster managed by Flux CD. The repository follows GitOps principles where all cluster configuration is stored in Git and automatically applied by Flux. The cluster is currently being refactored from a previous k3s implementation to use Talos Linux as the operating system.

## Development Commands

### Cluster Management

**Primary task runner:** Uses [Taskfile](https://taskfile.dev/) for automation

```bash
# View all available tasks
task

# Bootstrap the entire cluster from scratch
task bootstrap:talos      # Bootstrap Talos cluster
task bootstrap:flux       # Bootstrap Flux into cluster  
task bootstrap:apps       # Bootstrap applications

# Generate Age key for SOPS encryption
task bootstrap:age-keygen

# Force Flux to reconcile changes from Git
task reconcile
# Or alternatively:
flux --namespace flux-system reconcile kustomization flux-system --with-source
```

### Talos Operations

```bash
# Generate Talos configuration
task talos:generate-config

# Apply config to specific node (requires IP variable)
task talos:apply-node IP=192.168.20.5

# Upgrade Talos on single node
task talos:upgrade-node IP=192.168.20.5

# Upgrade Kubernetes version
task talos:upgrade-k8s

# Fetch kubeconfig from Talos cluster
task talos:fetch-kubeconfig

# Nuclear options (use with extreme caution)
task talos:soft-nuke      # Reset nodes to maintenance mode
task talos:hard-nuke      # Complete cluster reset
```

### Kubernetes Operations

```bash
# Apply specific Flux Kustomization
task kubernetes:apply-ks PATH=media/sonarr

# Validate Kubernetes manifests
task kubernetes:kubeconform

# Get cluster resources overview
task kubernetes:resources

# Delete failed pods across all namespaces
task kubernetes:delete-failed-pods

# Rook Ceph operations
task kubernetes:rook-ceph-toolbox    # Access Rook toolbox
task kubernetes:rook-password        # Get dashboard password
```

### Development Workflow

```bash
# Run pre-commit hooks manually
pre-commit run --all-files

# Lint YAML files
yamllint .

# Check for secrets in files
pre-commit run forbid-secrets --all-files
```

## Architecture Overview

### Directory Structure

- **`talos/`** - Talos Linux configuration using talhelper
- **`kubernetes/`** - All Kubernetes manifests managed by Flux
  - **`kubernetes/apps/`** - Application definitions organized by namespace
  - **`kubernetes/flux/`** - Flux system configuration
  - **`kubernetes/components/`** - Reusable Kustomize components
  - **`kubernetes/tools/`** - Utility manifests for maintenance
- **`bootstrap/`** - Initial cluster bootstrap configurations
- **`scripts/`** - Shell scripts for automation
- **`.taskfiles/`** - Task definitions organized by domain

### Flux GitOps Architecture

The cluster uses Flux CD with the following structure:

1. **Flux System** (`flux-system` namespace) manages the GitOps controller
2. **Cluster Meta** (`kubernetes/flux/meta/`) contains Helm repositories and other meta resources
3. **Cluster Apps** (`kubernetes/apps/`) contains all application configurations
4. **Kustomizations** Each app has a `ks.yaml` file defining its Flux Kustomization

### Talos Configuration

- **Configuration Template:** `talos/talconfig.yaml` with environment variable substitution
- **Cluster:** 3 control plane nodes + 3 worker nodes (192.168.20.5-10)
- **CNI:** None (Cilium installed via Flux)
- **Secrets Management:** SOPS + Age encryption

### SOPS Encryption

- **Configuration:** `.sops.yaml` defines encryption rules
- **Key Location:** `age.key` (gitignored)
- **Encrypted Files:** `*.sops.yaml` files throughout the repository
- **Usage:** All secrets are encrypted at rest in Git

### Application Organization

Applications are organized by namespace:
- **`cert-manager`** - Certificate management
- **`downloads`** - Download automation tools
- **`flux-system`** - Flux GitOps system
- **`kube-system`** - Core Kubernetes components
- **`media`** - Media server applications (Sonarr, Radarr, etc.)
- **`monitoring`** - Grafana, Prometheus monitoring stack
- **`networking`** - Network-related services
- **`rook-ceph`** - Distributed storage system
- **`system`** - System-level applications
- **`web-tools`** - Web-based utility applications

### Environment Variables

Key environment variables used in Talos configuration:
- **`CLUSTER_NAME`** - Cluster identifier
- **`DOMAINNAME`** - Domain suffix for nodes
- **`CLUSTERENDPOINTIP`** - Cluster API endpoint IP
- **`CLUSTER_PODNET`** - Pod network CIDR
- **`CLUSTER_SUBNET`** - Service network CIDR

## Key Files

- **`Taskfile.yml`** - Main task definitions and variables
- **`talos/talconfig.yaml`** - Talos cluster configuration template
- **`.sops.yaml`** - SOPS encryption configuration
- **`kubernetes/flux/cluster/ks.yaml`** - Main Flux cluster sync configuration
- **`scripts/bootstrap-apps.sh`** - Application bootstrap automation

## Prerequisites for Development

Must have installed:
- `task` - Task runner
- `talosctl` - Talos CLI
- `talhelper` - Talos configuration helper
- `kubectl` - Kubernetes CLI  
- `flux` - Flux CLI
- `sops` - Secret encryption
- `age` - Age encryption tool
- `helmfile` - Helm chart management
- `yq` - YAML processor

## Important Notes

- This cluster is currently in refactoring state from previous k3s setup
- All secrets must be encrypted with SOPS before committing
- Talos requires nodes to be in 'Ready=False' state before applying resources
- The cluster uses Cilium CNI installed via Flux (not Talos built-in)
- Bootstrap process is order-dependent: Talos → Flux → Apps
- Use `task` commands rather than direct CLI commands for consistency