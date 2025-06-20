variable "registry_namespace_wings_chart_endpoint" {
  description = "Registry Namespace Wings Chart Endpoint"
  type        = string
  sensitive   = true
}

variable "iam_api_key_argocd_access_key" {
  description = "API key for ArgoCD Access Key"
  type        = string
  sensitive   = true
}

variable "iam_api_key_argocd_secret_key" {
  description = "API key for ArgoCD Secret Key"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub Token"
  type        = string
  sensitive   = true
}
