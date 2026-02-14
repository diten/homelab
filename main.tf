resource "proxmox_virtual_environment_vm" "vm" {
  name        = "worker-01"
  description = "Managed by OpenTofu"
  node_name = "madrid" # Deploy this to Madrid node
  clone {
    vm_id = 9000              # This is how we clone the template
    source_node_name = "baires" # The node where the template currently resides
    full = true
  }
  #template_vm_id = 9000  # The ID of the template we just created

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "local-lvm" # Change to your Madrid storage name
    interface    = "scsi0"
    size         = 20
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