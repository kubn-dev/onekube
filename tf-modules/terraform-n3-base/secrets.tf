resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "kube-system"
  }
  data = {
    "${local.cloudflare_api_token_secret_key}" = var.cloudflare_api_token
  }
}
