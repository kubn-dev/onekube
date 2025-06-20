resource "cloudflare_registrar_domain" "main" {
  account_id  = var.cloudflare_account_id
  domain_name = var.cloudflare_domain_name
  auto_renew  = true
  locked      = true
  privacy     = true
}
