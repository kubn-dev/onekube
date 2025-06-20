terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2"
    }
  }
}
