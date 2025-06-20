resource "scaleway_iam_application" "argocd" {
  name        = "${data.scaleway_account_project.main.name}-argocd"
  description = "${data.scaleway_account_project.main.name} ArgoCD"
}

resource "scaleway_iam_application" "github_actions" {
  name        = "${data.scaleway_account_project.main.name}-github-actions"
  description = "${data.scaleway_account_project.main.name} GitHub Actions"
}

resource "scaleway_iam_policy" "container_registry_read_only" {
  name           = "${data.scaleway_account_project.main.name}-container-registry-ro"
  description    = "Read-Only access to the Container Registry"
  application_id = scaleway_iam_application.argocd.id
  rule {
    project_ids          = [var.scw_project_id]
    permission_set_names = ["ContainerRegistryReadOnly"]
  }
}

resource "scaleway_iam_policy" "container_registry_read_write" {
  name           = "${data.scaleway_account_project.main.name}-container-registry-rw"
  description    = "Read-write access to the Container Registry"
  application_id = scaleway_iam_application.github_actions.id
  rule {
    project_ids          = [var.scw_project_id]
    permission_set_names = ["ContainerRegistryFullAccess"]
  }
}

resource "scaleway_iam_api_key" "argocd" {
  description    = "API key for ArgoCD"
  application_id = scaleway_iam_application.argocd.id
}

resource "scaleway_iam_api_key" "github_actions" {
  description    = "API key for GitHub Actions"
  application_id = scaleway_iam_application.github_actions.id
}

resource "scaleway_registry_namespace" "wings_chart" {
  name        = "${data.scaleway_account_project.main.name}-wings-chart"
  description = "${data.scaleway_account_project.main.name} Wings Helm Chart"
  is_public   = false
}
