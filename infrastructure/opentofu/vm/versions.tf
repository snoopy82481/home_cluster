terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc9"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
  }
  required_version = ">=1.3.0"
}
