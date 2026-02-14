variable "proxmox_token_id" {
  type        = string
  description = "The ID of the Proxmox API Token (e.g. tofu-prov@pve!tofu-token)"
}

variable "proxmox_token_secret" {
  type        = string
  description = "The Secret of the Proxmox API Token"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "The SSH Public Key to be injected into VMs"
}