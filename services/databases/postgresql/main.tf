# 1. PostgreSQL LXC
resource "proxmox_virtual_environment_container" "postgres_db" {
  node_name = "baires"
  vm_id     = 120
  tags      = ["db", "tofu"]

  initialization {
    hostname = "postgres-db"
    ip_config {
      ipv4 {
        address = "192.168.18.120/24"
        gateway = "192.168.18.20"
      }
    }
    user_account {
      keys = [var.ssh_public_key]
    }
  }

  network_interface {
    name = "vmbr0"
  }

  operating_system {
    # Ensure this matches your specific template ID/Path
    template_file_id = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    type             = "debian"
  }

  mount_point {
    volume = "bulk:8" 
    path   = "/"
  }

  memory {
    dedicated = 2024
  }
}

# 2. PostgREST LXC
resource "proxmox_virtual_environment_container" "postgrest_api" {
  node_name = "baires"
  vm_id     = 121
  tags      = ["api", "tofu"]

  # Dependency ensures order
  depends_on = [proxmox_virtual_environment_container.postgres_db]

  initialization {
    hostname = "postgrest-api"
    ip_config {
      ipv4 {
        address = "192.168.18.121/24"
        gateway = "192.168.18.20"
      }
    }
    user_account {
      keys = [var.ssh_public_key]
    }
  }

  network_interface {
    name = "vmbr0"
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    type             = "debian"
  }

  memory {
    dedicated = 512
  }
}