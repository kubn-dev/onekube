locals {
  name          = "control"
  namespace     = "crossplane-system"
  namespace_app = "argocd"
  repo_raw      = "https://github.com/kubn-dev/onekube-control"
}

resource "argocd_project" "control_provider" {
  metadata {
    name      = "${local.name}-provider"
    namespace = local.namespace_app
  }
  spec {
    description       = "Control Provider project"
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

resource "argocd_repository" "control_provider" {
  repo     = "${local.repo_raw}.git"
  name     = "${local.name}-provider"
  username = "github"
  password = var.github_token
  project  = argocd_project.control_provider.metadata.0.name
}

resource "argocd_application" "control_provider" {
  metadata {
    name      = "${local.name}-provider"
    namespace = "argocd"
  }
  spec {
    project = argocd_project.control_provider.metadata.0.name
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.namespace
    }
    source {
      repo_url        = local.repo_raw
      target_revision = "HEAD"
      path            = "provider"
    }
    sync_policy {
      sync_options = [
        "CreateNamespace=true",
        "ApplyOutOfSyncOnly=true",
        "PruneLast=true"
      ]
    }
  }
  depends_on = [argocd_repository.control_provider]
}

resource "argocd_project" "control_config" {
  metadata {
    name      = "${local.name}-config"
    namespace = local.namespace_app
  }
  spec {
    description       = "Control Config project"
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

resource "argocd_repository" "control_config" {
  repo     = "${local.repo_raw}.git"
  name     = "${local.name}-config"
  username = "github"
  password = var.github_token
  project  = argocd_project.control_config.metadata.0.name
}

resource "argocd_application" "control_config" {
  metadata {
    name      = "${local.name}-config"
    namespace = "argocd"
  }
  spec {
    project = argocd_project.control_config.metadata.0.name
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = local.namespace
    }
    source {
      repo_url        = local.repo_raw
      target_revision = "HEAD"
      path            = "config"
    }
    sync_policy {
      sync_options = [
        "CreateNamespace=true",
        "ApplyOutOfSyncOnly=true",
        "PruneLast=true"
      ]
    }
  }
  depends_on = [
    argocd_repository.control_config,
    argocd_project.control_provider
  ]
}

