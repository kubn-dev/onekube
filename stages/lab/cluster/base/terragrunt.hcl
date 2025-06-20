include "root" {
  path   = "${get_repo_root()}/stages/lab/terragrunt-root.hcl"
  expose = true
}

dependency "cluster" {
  config_path = "${get_repo_root()}/stages/lab/cluster"
}

terraform {
  source = "${get_repo_root()}/tf-modules/terraform-n3-base"
}

inputs = {
  scw_organization_id            = get_env("SCW_DEFAULT_ORGANIZATION_ID")
  scw_project_id                 = get_env("SCW_DEFAULT_PROJECT_ID")
  scw_region                     = get_env("SCW_DEFAULT_REGION")
  scw_zone                       = get_env("SCW_DEFAULT_ZONE")
  scw_cluster_name               = dependency.cluster.outputs.scw_cluster_name
  scw_cluster_host               = dependency.cluster.outputs.scw_cluster_host
  scw_cluster_ca_certificate     = dependency.cluster.outputs.scw_cluster_ca_certificate
  scw_cluster_token              = dependency.cluster.outputs.scw_cluster_token
  cloudflare_api_token           = get_env("CLOUDFLARE_API_TOKEN")
  cloudflare_domain_name         = dependency.cluster.outputs.cloudflare_domain_name
  github_oauth_client_id         = get_env("GITHUB_OAUTH_CLIENT_ID")
  github_oauth_client_secret     = get_env("GITHUB_OAUTH_CLIENT_SECRET")
  google_project_id              = get_env("GOOGLE_PROJECT_ID")
  google_region                  = get_env("GOOGLE_REGION")
  google_oauth_client_id         = get_env("GOOGLE_OAUTH_CLIENT_ID")
  google_oauth_client_secret     = get_env("GOOGLE_OAUTH_CLIENT_SECRET")
  google_oauth_hosted_domain     = get_env("GOOGLE_OAUTH_HOSTED_DOMAIN")
  google_dex_service_account_key = dependency.cluster.outputs.google_dex_service_account_key
  email                          = get_env("EMAIL")
}