provider "google" {
  project = var.google_project_id
  region  = var.google_region
}

provider "helm" {
  kubernetes {
    host                   = var.scw_cluster_host
    cluster_ca_certificate = base64decode(var.scw_cluster_ca_certificate)
    token                  = var.scw_cluster_token
  }
}

provider "kubectl" {
  host                   = var.scw_cluster_host
  cluster_ca_certificate = base64decode(var.scw_cluster_ca_certificate)
  token                  = var.scw_cluster_token
  load_config_file       = false
}

provider "kubernetes" {
  host                   = var.scw_cluster_host
  cluster_ca_certificate = base64decode(var.scw_cluster_ca_certificate)
  token                  = var.scw_cluster_token
}
