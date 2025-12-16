terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
  }
  required_version = ">=1.3.0"
}
