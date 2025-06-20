output "scw_iam_api_key_argocd_access_key" {
  description = "API key for ArgoCD Access Key"
  value       = scaleway_iam_api_key.argocd.access_key
  sensitive   = true
}

output "scw_iam_api_key_argocd_secret_key" {
  description = "API key for ArgoCD Secret Key"
  value       = scaleway_iam_api_key.argocd.secret_key
  sensitive   = true
}

output "scw_iam_api_key_github_actions_access_key" {
  description = "API key for GitHub Actions Access Key"
  value       = scaleway_iam_api_key.github_actions.access_key
  sensitive   = true
}

output "scw_iam_api_key_github_actions_secret_key" {
  description = "API key for GitHub Actions Secret Key"
  value       = scaleway_iam_api_key.github_actions.secret_key
  sensitive   = true
}

output "scw_registry_namespace_wings_chart_endpoint" {
  description = "Wings Helm Chart Namespace Endpoint"
  value       = scaleway_registry_namespace.wings_chart.endpoint
  sensitive   = true
}

output "scw_compute_instances_security_group_inbound_rules_instructions" {
  description = "Reminder for the manual Compute Instance Security Group Inbound Rules setup step."
  value       = <<EOT
SCALEWAY CONSOLE; MANUAL STEP REQUIRED:
1. Go to your Scaleway Console (console.scaleway.com).
2. Navigate to: Compute > Instances.
3. Under 'Security groups', locate 'kubernetes <cluster-id>'.
4. Click 'Rules', click the 'Edit' icon button and click "Add an inbound rule".
5. Create two inbound rules:
    * Rule: Accept, Protocol: TCP, Port: 80, IP Range: 0.0.0.0/0
    * Rule: Accept, Protocol: TCP, Port: 443, IP Range: 0.0.0.0/0
EOT
}

output "vault_setup_instructions" {
  description = "Vault setup instructions."
  value       = <<EOT
MANUAL STEP REQUIRED:
Run the following command to initialize Hashicorp Vault:
kubectl exec vault-0 -- vault operator init -key-shares=3 -key-threshold=3 -format=json > cluster-keys.json
# This will create a file named 'cluster-keys.json' with the unseal keys and root token.
# Make sure to keep this file secure and do not share it publicly.
# You can use the following command to unseal Vault:
# kubectl exec vault-0 -- vault operator unseal <unseal_key>
# And to login to Vault:
# kubectl exec vault-0 -- vault login <root_token>
EOT
}
