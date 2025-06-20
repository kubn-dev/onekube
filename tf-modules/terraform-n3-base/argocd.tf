resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.7.11"
  wait       = true
  values = [templatefile("${path.module}/files/values/argocd.yaml", {
    host                                       = "argocd.${var.cloudflare_domain_name}"
    host_grpc                                  = "argocd-grpc.${var.cloudflare_domain_name}"
    host_applicationset                        = "argocd-applicationset.${var.cloudflare_domain_name}"
    google_oauth_client_id                     = var.google_oauth_client_id
    google_oauth_client_secret                 = var.google_oauth_client_secret
    google_oauth_hosted_domain                 = var.google_oauth_hosted_domain
    google_dex_service_account_key_secret_name = kubernetes_secret.google_dex_service_account_key.metadata.0.name
    email                                      = var.email
    replicas                                   = local.argocd_ha == true ? 3 : 1
  })]
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "kubernetes_namespace" "crossplane_system" {
  metadata {
    name = "crossplane-system"
  }
}

resource "kubernetes_namespace" "wings" {
  metadata {
    name = "wings"
  }
}

resource "kubernetes_secret" "google_dex_service_account_key" {
  metadata {
    name      = "google-dex-service-account-key"
    namespace = kubernetes_namespace.argocd.metadata.0.name
  }
  data = {
    key = base64decode(var.google_dex_service_account_key)
  }
  type = "Opaque"
}

resource "kubernetes_manifest" "wildcart_certificate_push_secret" {
  manifest = yamldecode(<<EOF
apiVersion: external-secrets.io/v1alpha1
kind: PushSecret
metadata:
  name: ${local.wildcard_certificate_name}
  namespace: argocd
spec:
  updatePolicy: Replace
  deletionPolicy: Delete
  refreshInterval: 1h
  secretStoreRefs:
    - name: scaleway
      kind: ClusterSecretStore
  selector:
    secret:
      name: argocd-server-tls
    # Alternatively, you can point to a generator that produces values to be pushed
    # generatorRef:
    #   apiVersion: generators.external-secrets.io/v1alpha1
    #   kind: ECRAuthorizationToken
    #   name: prod-registry-credentials
  data:
    - conversionStrategy: None
      match:
        secretKey: tls.crt
        remoteRef:
          remoteKey: "${local.wildcard_certificate_crt}"
    - conversionStrategy: None
      match:
        secretKey: tls.key
        remoteRef:
          remoteKey: "${local.wildcard_certificate_key}"
EOF
  )
  depends_on = [kubernetes_manifest.external_secrets_operator]
  field_manager {
    force_conflicts = true
  }
}
