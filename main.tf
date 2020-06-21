provider "kubernetes" {
  config_path = "kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig"
  }
}

resource "kubernetes_namespace" "argo-ns" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "msur"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd"

  # Adding a depends_on ensures that the argo helm package will be uninstalled before the EKS cluster is removed.  
  depends_on = [var.kubernetes_cluster_id]
}