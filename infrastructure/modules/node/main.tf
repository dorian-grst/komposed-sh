resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.pve_node
  on_boot   = true
  vm_id     = var.id

  machine = "q35"
  scsi_hardware = "virtio-scsi-single"
  bios = "seabios"

  started = true
  cpu {
    cores = 1
    type  = "host"
  }

  memory {
    dedicated = 8192
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.storage_pool
    interface  = "scsi0"
    iothread = true
    cache = "writethrough"
    discard = "on"
    ssd = true
    file_format = "raw"
    size = 32
    file_id = var.talos_img
  }

  boot_order = ["scsi0"]

  operating_system {
    type = "l26"
  }

  initialization {
    datastore_id = var.storage_pool
    ip_config {
      ipv4 {
        address = "${var.network.ip}/24"
        gateway = var.network.gw
      }
    }
    dns {
      domain  = ""
      servers = var.network.nameservers
    }
  }
}
  
