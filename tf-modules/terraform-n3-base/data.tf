locals {
  wildcard_certificate_name = "wildcard-certificate"
  wildcard_certificate_crt  = "name:wildcard-certificate-tls-crt"
  wildcard_certificate_key  = "name:wildcard-certificate-tls-key"
}

data "scaleway_account_project" "main" {
  project_id = var.scw_project_id
}

data "google_project" "main" {
  project_id = var.google_project_id
}
