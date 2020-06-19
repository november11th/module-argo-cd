provider "kubernetes" {
  load_config_file = false
  config_path = "kubeconfig"
}

provider "helm" {}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "msur"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"
}