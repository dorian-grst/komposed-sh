variable "talos_version" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "gryffondor-3"
}

variable "nodes" {
  type = list(object({
    name     = string
    ip       = string
    role     = string
    hostname = string
  }))
}

variable "cilium" {
  type = object({
    values  = string
    install = string
  })
}

variable "longhorn" {
  type = object({
    install = string
  })
}
