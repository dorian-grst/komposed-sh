resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "8.0.17"
  timeout    = "1500"
  namespace  = kubernetes_namespace.argocd.id
  values = [file("${path.module}/argocd-values.yaml")]
}


resource "null_resource" "install_crds" {
  for_each   = var.crds
  provisioner "local-exec" {
    command = "kubectl apply -f ${each.value}"
  }
}

resource "kubernetes_manifest" "argocd_application" {
  depends_on = [kubernetes_manifest.argocd_project]
  manifest = yamldecode(file("${path.module}/argocd-application.yaml"))
}

resource "kubernetes_manifest" "argocd_project" {
  depends_on = [null_resource.install_crds, helm_release.argocd]
  manifest = yamldecode(file("${path.module}/argocd-project.yaml"))
}
