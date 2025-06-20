resource "helm_release" "traefik" {
  name       = "traefik"
  namespace  = "kube-system"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  version    = "34.4.1"
  wait       = true
  values = [templatefile("${path.module}/files/values/traefik.yaml", {
    cloudflare_api_token_secret_name = kubernetes_secret.cloudflare_api_token.metadata.0.name
    cloudflare_api_token_secret_key  = local.cloudflare_api_token_secret_key
    email                            = var.email
    host                             = "traefik.${var.cloudflare_domain_name}"
  })]
}
