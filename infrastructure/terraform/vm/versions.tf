terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.0.0"
    }
  }
  required_version = ">=1.3.0"
}
