variable "proxmox_host" {
  description = "Name of the proxmost host inside the proxmox datacenter"
  type        = string
  default     = "proxmox"
}

# master variables
variable "master_hostname" {
  description = "Talos Master VM's to be created"
  type        = list(string)
  default     = ["kmaster1", "kmaster2", "kmaster3"]
}

variable "master_vmid" {
  description = "Starting ID for Master VM's"
  type        = number
  default     = 300
}

variable "master_mac" {
  description = "MAC's for Master VM's"
  type        = list(string)
  default     = ["5a:a0:b4:c2:70:67", "4e:ba:97:3f:c6:92", "1a:37:36:31:49:bb"]
}

# Worker variables
variable "worker_hostname" {
  description = "Talos Worker VM's to be created"
  type        = list(string)
  default     = ["kworker1", "kworker2", "kworker3"]
}

variable "worker_vmid" {
  description = "Starting ID for Master VM's"
  type        = number
  default     = 303
}

variable "worker_mac" {
  description = "MAC's for Master VM's"
  type        = list(string)
  default     = ["3e:34:a5:07:d3:cd", "ba:f9:08:ad:95:16", "66:4a:42:25:c9:eb"]
}
