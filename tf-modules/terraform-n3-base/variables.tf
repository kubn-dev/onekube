locals {
  cloudflare_api_token_secret_key = "api.token"
  argocd_ha                       = true
}

variable "scw_organization_id" {
  description = "Scaleway Organization ID"
  type        = string
}

variable "scw_project_id" {
  description = "Scaleway Project ID"
  type        = string
}

variable "scw_region" {
  description = "Scaleway Region"
  type        = string
}

variable "scw_zone" {
  description = "Scaleway Zone"
  type        = string
}

variable "scw_cluster_name" {
  description = "Scaleway Cluster Name"
  type        = string
}

variable "scw_cluster_host" {
  description = "Scaleway Cluster Host"
  type        = string
}

variable "scw_cluster_ca_certificate" {
  description = "Scaleway Cluster CA Certificate"
  type        = string
}

variable "scw_cluster_token" {
  description = "Scaleway Cluster Token"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_domain_name" {
  description = "Cloudflare Domain Name"
  type        = string
}

variable "google_project_id" {
  description = "Google Project ID"
  type        = string
}

variable "google_region" {
  description = "Google Region"
  type        = string
}

variable "google_oauth_client_id" {
  description = "Google OAuth Client ID"
  type        = string
}

variable "google_oauth_client_secret" {
  description = "Google OAuth Client Secret"
  type        = string
}

variable "google_oauth_hosted_domain" {
  description = "Google OAuth Hosted Domain"
  type        = string
}

variable "google_dex_service_account_key" {
  description = "Google DEX Service Account Key"
  type        = string
}

variable "github_oauth_client_id" {
  description = "GitHub OAuth Client ID"
  type        = string
  sensitive   = true
}

variable "github_oauth_client_secret" {
  description = "GitHub OAuth Client Secret"
  type        = string
  sensitive   = true
}

variable "email" {
  description = "Email"
  type        = string
}
