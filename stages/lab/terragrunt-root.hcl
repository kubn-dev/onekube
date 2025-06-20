remote_state {
  backend = "gcs"
  config = {
    project  = "n3-ring0"
    bucket   = "n3-states"
    location = "europe"
    prefix   = "n3-onekube/${get_path_from_repo_root()}"
  }
}

terraform_version_constraint  = ">= 1.7"
terragrunt_version_constraint = ">= 0.58"

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.0"
    }
  }
}

EOF
}

retryable_errors = [
  "(?s).*Failed to load state.*tcp.*timeout.*",
  "(?s).*Failed to load backend.*TLS handshake timeout.*",
  "(?s).*Creating metric alarm failed.*request to update this alarm is in progress.*",
  "(?s).*Error installing provider.*TLS handshake timeout.*",
  "(?s).*Error configuring the backend.*TLS handshake timeout.*",
  "(?s).*Error installing provider.*tcp.*timeout.*",
  "(?s).*Error installing provider.*tcp.*connection reset by peer.*",
  "NoSuchBucket: The specified bucket does not exist",
  "(?s).*Error creating SSM parameter: TooManyUpdates:.*",
  "(?s).*app.terraform.io.*: 429 Too Many Requests.*",
  "(?s).*ssh_exchange_identification.*Connection closed by remote host.*",
  "(?s).*Client\\.Timeout exceeded while awaiting headers.*",
  "(?s).*Could not download module.*The requested URL returned error: 429.*",
  "(?s).*Internal error occurred: failed calling webhook \"mservice.elbv2.k8s.aws\": failed to call webhook.*",
]