include "root" {
  path   = "${get_repo_root()}/stages/lab/terragrunt-root.hcl"
  expose = true
}

terraform {
  source = "${get_repo_root()}/tf-modules/terraform-n3-cluster"
}

inputs = {
  scw_organization_id       = get_env("SCW_DEFAULT_ORGANIZATION_ID")
  scw_project_id            = get_env("SCW_DEFAULT_PROJECT_ID")
  scw_region                = get_env("SCW_DEFAULT_REGION")
  scw_zone                  = get_env("SCW_DEFAULT_ZONE")
  scw_vpc_id                = get_env("SCW_DEFAULT_VPC_ID")
  cloudflare_api_key        = get_env("CLOUDFLARE_API_KEY")
  cloudflare_email          = get_env("CLOUDFLARE_EMAIL")
  cloudflare_account_id     = get_env("CLOUDFLARE_ACCOUNT_ID")
  cloudflare_domain_name    = get_env("CLOUDFLARE_DOMAIN_NAME")
  cloudflare_domain_zone_id = get_env("CLOUDFLARE_DOMAIN_ZONE_ID")
  google_region             = get_env("GOOGLE_REGION")
  google_project_id         = get_env("GOOGLE_PROJECT_ID")
  email                     = get_env("EMAIL")
}
