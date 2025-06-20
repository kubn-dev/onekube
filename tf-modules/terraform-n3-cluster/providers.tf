provider "cloudflare" {
  api_key = var.cloudflare_api_key
  email   = var.cloudflare_email
}

provider "google" {
  project = var.google_project_id
  region  = var.google_region
}

provider "scaleway" {
  organization_id = var.scw_organization_id
  project_id      = var.scw_project_id
  zone            = var.scw_zone
  region          = var.scw_region
}

