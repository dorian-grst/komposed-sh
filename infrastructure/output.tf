output "kubeconfig" {
  value = module.talos.kubeconfig["kubeconfig_raw"]
  sensitive = true
}
