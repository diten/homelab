terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.96.1"
    }
  }

  backend "local" {
    path = "/opt/opentofu/state/homelab.tfstate"
  }

}


provider "proxmox" {
  # The internal IP of your Baires node
  endpoint = "https://192.168.18.20:8006"
  
  # This matches the environment variables you will set in GitHub Actions
  api_token = "${var.proxmox_token_id}=${var.proxmox_token_secret}"
  
  # Since you are using a self-signed cert on Proxmox
  insecure = true

  # Optional: point to your Baires node specifically
  ssh {
    agent = true
    # This helps for some advanced disk operations
    node {
      name    = "baires"
      address = "192.168.18.20"
    }
  }
}