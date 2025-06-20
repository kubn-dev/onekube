output "scw_cluster_name" {
  value = scaleway_k8s_cluster.main.name
}

output "scw_cluster_host" {
  value     = scaleway_k8s_cluster.main.kubeconfig.0.host
  sensitive = true
}

output "scw_cluster_ca_certificate" {
  value     = scaleway_k8s_cluster.main.kubeconfig.0.cluster_ca_certificate
  sensitive = true
}

output "scw_cluster_token" {
  value     = scaleway_k8s_cluster.main.kubeconfig.0.token
  sensitive = true
}

output "cloudflare_domain_name" {
  value = cloudflare_registrar_domain.main.domain_name
}

output "google_dex_service_account_email" {
  value = google_service_account.main.email
}

output "google_dex_service_account_key" {
  value     = google_service_account_key.main.private_key
  sensitive = true
}

output "google_workspace_admin_console_manual_dwd_setup_instructions" {
  description = "Reminder for the manual Google Workspace Admin Domain-Wide Delegation setup step."
  value       = <<EOT
GOOGLE WORKSPACE ADMIN CONSOLE; MANUAL STEP REQUIRED:
1. Go to your Google Workspace Admin Console (admin.google.com).
2. Navigate to: Security > Access and data control > API Controls.
3. Under 'Domain-wide Delegation', click 'MANAGE DOMAIN-WIDE DELEGATION'.
4. Click 'Add new'.
5. Enter the Client ID: ${google_service_account.main.unique_id}
6. Enter the OAuth Scope: https://www.googleapis.com/auth/admin.directory.group.readonly
7. Click 'Authorize'.
EOT
}
