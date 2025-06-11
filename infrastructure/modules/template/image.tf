resource "proxmox_virtual_environment_download_file" "this" {
  node_name    = var.node_name
  content_type = "iso"
  datastore_id = "local"

  file_name = "talos-crt.img"
  url       = var.talos_url

  decompression_algorithm = "gz"
  overwrite               = false

  lifecycle {
    prevent_destroy = false
  }

  upload_timeout = 1200
}
