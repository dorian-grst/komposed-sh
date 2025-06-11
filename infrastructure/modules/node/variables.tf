variable "prefix" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "pve_node" {
  type = string
}

variable "storage_pool" {
  type = string
}

variable "network" {
  type = object({
    name        = string
    ip          = string
    gw          = string
    nameservers = list(string)
  })
}


variable "id" {
  type = string
}

variable "talos_img" {
  type = string
}
