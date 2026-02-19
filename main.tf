resource "proxmox_virtual_environment_vm" "vm" {
  name        = "worker-01"
  description = "Managed by OpenTofu"
  node_name = "madrid" # Deploy this to Madrid node
  clone {
    vm_id = 9000              # This is how we clone the template
    node_name = "baires" # The node where the template currently resides
    full = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
  }
  
  serial_device {} 

  vga {
    type = "serial0"
  }

  disk {
    datastore_id = "local-lvm" # Change to your Madrid storage name
    size         = 20
    interface = "scsi0"
  }

  agent {
    enabled = false
  }

  initialization {

    ip_config {
      ipv4 {
        address = "192.168.18.101/24"
        gateway = "192.168.18.20"
      }
    }
    
    # Replace with your actual SSH public key
    user_account {
      keys     = [var.ssh_public_key]
      username = "root"
    }
  }
}

module "database_stack" {
  source = "./services/databases/postgresql"
  # Pass your variables down to the module
  ssh_public_key = var.ssh_public_key
  proxmox_token_id = var.proxmox_token_id
  proxmox_token_secret = var.proxmox_token_secret
}