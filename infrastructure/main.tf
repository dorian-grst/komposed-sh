terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.37.1"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.0.0-pre2"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.19.0"
    }
  }
}

locals {
  node_name = "gryffondor-3"
}
provider "proxmox" {
  endpoint = "https://162.38.112.67:8006/"
  insecure = true
  ssh {
    agent = true
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "admin@gryffondor"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "kubectl" {
  load_config_file       = true
  config_path            = "~/.kube/config"
}


variable "cluster" {
  type = object({
    name = string
    storage_pool = string
    node = string
    ssh_user = string
    ssh_key = string
    nodes = list(object({
      name = string
      interface = string
      ip = string
      gw = string
      nameservers = list(string)
      id = string
      role = string
    }))
  })
}

module "template" {
  source = "./modules/template"
  node_name = local.node_name
  talos_url ="https://factory.talos.dev/image/9da91404d9f8586bcf78143057fb82d8c50e5556ecc7d78192dfc23b428d4d4b/v1.10.3/nocloud-amd64.raw.gz"
}

module "node" {
  for_each = tomap({
    for v in var.cluster.nodes : "${v.name}-${v.role}" => v
  })
  source = "./modules/node"
  talos_img = module.template.talos_img

  prefix       = var.cluster.name
  ssh_key      = var.cluster.ssh_key
  vm_name      = each.value.name
  pve_node     = var.cluster.node
  storage_pool = var.cluster.storage_pool
  network = {
    name        = each.value.interface
    ip          = each.value.ip
    gw          = each.value.gw
    nameservers = each.value.nameservers
  }
  ssh_user = var.cluster.ssh_user
  id = each.value.id
}

module "talos" {
  source = "./modules/talos"
  talos_version = "v1.10.3"
  depends_on = [module.node]
  cilium = {
    install = file("${path.module}/modules/talos/cilium.yaml")
    values = file("${path.module}/modules/talos/cilium-values.yaml")
  }

  longhorn = {
    install = file("${path.module}/modules/talos/longhorn.yaml")
  }

  nodes = [for k, v in var.cluster.nodes : {
    name     = v.name
    ip       = v.ip
    role     = v.role
    hostname = v.name
  }]
  cluster_name = var.cluster.name

}

module "services" {
  source = "./modules/services"
}
