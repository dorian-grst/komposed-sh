resource "talos_machine_secrets" "talos" {
  talos_version = var.talos_version
}

data "talos_client_configuration" "talos" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.talos.client_configuration
  nodes                = [for k, v in var.nodes : v.ip]
  endpoints            = [for k, v in var.nodes : v.ip if v.role == "controlplane"]
}

locals {
  cluster_ip = [for k, v in var.nodes : v.ip if v.role == "controlplane"][0]
}

data "talos_machine_configuration" "talos" {
  for_each = tomap({
    for v in var.nodes : "${v.ip}-${v.role}" => v
  })
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${local.cluster_ip}:6443"
  talos_version    = var.talos_version
  machine_type     = each.value.role
  machine_secrets  = talos_machine_secrets.talos.machine_secrets
  config_patches = each.value.role == "controlplane" ? [
    templatefile("${path.module}/configs/controlplane.yaml.tpl", {
      hostname         = each.value.hostname
      node_name        = each.value.name
      cluster_name     = var.cluster_name
      cilium_values    = var.cilium.values
      cilium_install   = var.cilium.install
      longhorn_install = var.longhorn.install
    })
    ] : [
    templatefile("${path.module}/configs/worker.yaml.tpl", {
      hostname     = each.value.hostname
      node_name    = each.value.name
      cluster_name = var.cluster_name
    })
  ]
}

resource "talos_machine_configuration_apply" "talos" {
  for_each                    = tomap({
    for v in var.nodes : "${v.ip}-${v.role}" => v
  })
  node                        = each.value.ip
  client_configuration        = talos_machine_secrets.talos.client_configuration
  machine_configuration_input = data.talos_machine_configuration.talos[each.key].machine_configuration
}

resource "talos_machine_bootstrap" "talos" {
  node                 = [for k, v in var.nodes : v.ip if v.role == "controlplane"][0]
  endpoint             = local.cluster_ip
  client_configuration = talos_machine_secrets.talos.client_configuration
}

resource "talos_cluster_kubeconfig" "talos" {
  depends_on           = [talos_machine_bootstrap.talos]
  node                 = [for k, v in var.nodes : v.ip if v.role == "controlplane"][0]
  endpoint             = local.cluster_ip
  client_configuration = data.talos_client_configuration.talos.client_configuration
  timeouts = {
    read = "1m"
  }
}
