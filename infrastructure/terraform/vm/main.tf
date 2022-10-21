data "sops_file" "proxmox_secrets" {
  source_file = "secret.sops.yaml"
}

provider "proxmox" {
  pm_api_url          = "https://192.168.1.101:8006/api2/json"
  pm_api_token_id     = data.sops_file.proxmox_secrets.data["token_id"]
  pm_api_token_secret = data.sops_file.proxmox_secrets.data["token_secret"]
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "talos_master" {
  count = length(var.master_hostname)
  name  = var.master_hostname[count.index]

  target_node = var.proxmox_host
  vmid        = var.master_vmid + count.index
  iso         = "local:iso/talos-amd64.iso"

  agent    = 0
  os_type  = "linux"
  cores    = 6
  sockets  = 1
  cpu      = "IvyBridge"
  memory   = 16384
  scsihw   = "virtio-scsi-pci"
  boot     = "cdn"
  bootdisk = "scsi0"
  oncreate = false

  disk {
    slot     = 0
    size     = "20G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
    discard  = "on"
  }

  network {
    model   = "virtio"
    bridge  = "vmbr1"
    macaddr = var.master_mac[count.index]
  }
}

resource "proxmox_vm_qemu" "talos_worker" {
  count = length(var.worker_hostname)
  name  = var.worker_hostname[count.index]

  target_node = var.proxmox_host
  vmid        = var.worker_vmid + count.index
  iso         = "local:iso/talos-amd64.iso"

  agent    = 0
  os_type  = "linux"
  cores    = 4
  sockets  = 1
  cpu      = "IvyBridge"
  memory   = 12288
  scsihw   = "virtio-scsi-pci"
  boot     = "cdn"
  bootdisk = "scsi0"
  oncreate = false

  disk {
    slot     = 0
    size     = "20G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
    discard  = "on"
  }

  disk {
    slot     = 1
    size     = "100G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
    discard  = "on"
  }

  network {
    model   = "virtio"
    bridge  = "vmbr1"
    macaddr = var.worker_mac[count.index]
  }
}
