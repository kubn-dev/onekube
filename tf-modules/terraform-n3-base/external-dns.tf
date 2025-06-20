resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.16.0"
  wait       = true
  values = [templatefile("${path.module}/files/values/external-dns.yaml", {
    cloudflare_api_token_secret_name = kubernetes_secret.cloudflare_api_token.metadata.0.name
    cloudflare_api_token_secret_key  = local.cloudflare_api_token_secret_key
  })]
}
