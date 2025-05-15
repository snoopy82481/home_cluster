data "sops_file" "proxmox_secrets" {
  source_file = "secret.sops.yaml"
}

provider "proxmox" {
  pm_api_url          = "https://192.168.0.3:8006/api2/json"
  pm_api_token_id     = data.sops_file.proxmox_secrets.data["token_id"]
  pm_api_token_secret = data.sops_file.proxmox_secrets.data["token_secret"]
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "talos_master" {
  count = length(var.master_hostname)
  name  = var.master_hostname[count.index]

  target_node = var.proxmox_host
  vmid        = var.master_vmid + count.index

  agent     = 1
  os_type   = "linux"
  qemu_os   = "l26"
  cores     = 3
  sockets   = 2
  cpu_type  = "IvyBridge"
  balloon   = 0
  memory    = 16384
  scsihw    = "virtio-scsi-pci"
  boot      = "order=sata0;sata1"
  vm_state  = "running"
  onboot    = true
  startup   = "order=15,up=30"
  skip_ipv6 = true

  disks {
    sata {
      sata0 {
        disk {
          size    = "40G"
          storage = "local-lvm"
          discard = true
        }
      }
      sata1 {
        cdrom {
          iso = "local:iso/metal-amd64.iso"
        }
      }
    }
  }


  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
    mtu     = 1
    tag     = 20
    macaddr = var.master_mac[count.index]
  }
}

resource "proxmox_vm_qemu" "talos_worker" {
  count = length(var.worker_hostname)
  name  = var.worker_hostname[count.index]

  target_node = var.proxmox_host
  vmid        = var.worker_vmid + count.index

  agent     = 1
  os_type   = "linux"
  qemu_os   = "l26"
  cores     = 2
  sockets   = 2
  cpu_type  = "IvyBridge"
  balloon   = 0
  memory    = 20480
  scsihw    = "virtio-scsi-pci"
  boot      = "order=sata0;sata2"
  vm_state  = "running"
  onboot    = true
  startup   = "order=15,up=30"
  skip_ipv6 = true

  disks {
    sata {
      sata0 {
        disk {
          size    = "40G"
          storage = "local-lvm"
          discard = true
        }
      }
      sata1 {
        disk {
          size    = "100G"
          storage = "local-lvm"
          discard = true
        }
      }
      sata2 {
        cdrom {
          iso = "local:iso/metal-amd64.iso"
        }
      }
    }
  }

  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
    mtu     = 1
    tag     = 20
    macaddr = var.worker_mac[count.index]
  }
}
