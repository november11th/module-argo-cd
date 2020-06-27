provider "kubernetes" {
  config_path = "kubeconfig"
}

# This isn't working at the moment because the kubeconfig file is not available
# We may need to pass all of the kube context and avoid using the file
provider "helm" {
  kubernetes {
    load_config_file       = false
    cluster_ca_certificate = base64decode("${var.kubernetes_cluster_cert_data}")
    host                   = var.kubernetes_cluster_endpoint
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      command     = "aws-iam-authenticator"
      args        = ["token", "-i", "${var.kubernetes_cluster_name}"]
    }
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