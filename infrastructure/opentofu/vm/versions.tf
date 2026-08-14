terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc09"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }
  required_version = ">=1.3.0"
}
