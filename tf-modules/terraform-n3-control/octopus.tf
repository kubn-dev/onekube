resource "argocd_project" "octopus" {
  metadata {
    name      = "octopus"
    namespace = local.namespace_app
  }
  spec {
    description       = "Octopus project"
    source_namespaces = [local.namespace_app]
    source_repos      = ["*"]
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.namespace_app
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.namespace
    }
    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }
}

resource "argocd_repository" "octopus" {
  repo     = "https://github.com/kubn-dev/onekube-octopus.git"
  name     = "octopus"
  username = "github"
  password = var.github_token
}

resource "argocd_application" "octopus" {
  metadata {
    name      = "octopus"
    namespace = "argocd"
  }
  spec {
    project = argocd_project.octopus.metadata.0.name
    source {
      repo_url        = argocd_repository.octopus.repo
      target_revision = "HEAD"
      path            = "."

    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }
    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
      sync_options = [
        "CreateNamespace=true",
      ]
    }
  }
}
