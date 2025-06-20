include "root" {
  path   = "${get_repo_root()}/stages/lab/terragrunt-root.hcl"
  expose = true
}

dependency "cluster" {
  config_path = "${get_repo_root()}/stages/lab/cluster"
}

dependency "base" {
  config_path = "${get_repo_root()}/stages/lab/cluster/base"
}

terraform {
  source = "${get_repo_root()}/tf-modules/terraform-n3-control"
}

inputs = {
  registry_namespace_wings_chart_endpoint = dependency.base.outputs.scw_registry_namespace_wings_chart_endpoint
  iam_api_key_argocd_access_key           = dependency.base.outputs.scw_iam_api_key_argocd_access_key
  iam_api_key_argocd_secret_key           = dependency.base.outputs.scw_iam_api_key_argocd_secret_key
  github_token                            = get_env("GITHUB_TOKEN")
}