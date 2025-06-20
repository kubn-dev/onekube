resource "helm_release" "kargo" {
  name       = "kargo"
  namespace  = kubernetes_namespace.kargo.metadata.0.name
  repository = "oci://ghcr.io/akuity/kargo-charts"
  chart      = "kargo"
  version    = "1.4.4"
  wait       = true
  values = [templatefile("${path.module}/files/values/kargo.yaml", {
    host                                       = "kargo.${var.cloudflare_domain_name}"
    host_argocd                                = "argocd.${var.cloudflare_domain_name}"
    google_oauth_client_id                     = var.google_oauth_client_id
    google_oauth_client_secret                 = var.google_oauth_client_secret
    google_oauth_hosted_domain                 = var.google_oauth_hosted_domain
    google_dex_service_account_key_secret_name = kubernetes_secret.kargo_google_dex_service_account_key.metadata.0.name
    kargo_password_hash                        = random_password.kargo_admin.bcrypt_hash
    kargo_token_signing_key                    = random_password.kargo_signing_key.result
    domain                                     = var.cloudflare_domain_name
    email                                      = var.email
  })]
}

resource "random_password" "kargo_admin" {
  length = 32
}

resource "random_password" "kargo_signing_key" {
  length  = 64
  special = false
}

resource "kubernetes_namespace" "kargo" {
  metadata {
    name = "kargo"
  }
}

resource "kubernetes_secret" "kargo_google_dex_service_account_key" {
  metadata {
    name      = "google-dex-service-account-key"
    namespace = kubernetes_namespace.kargo.metadata.0.name
  }
  data = {
    key = base64decode(var.google_dex_service_account_key)
  }
  type = "Opaque"
}

# resource "kubernetes_manifest" "kargo_api_cert" {
#   depends_on = [kubernetes_manifest.wildcart_certificate_push_secret]
#   manifest = yamldecode(<<EOF
# apiVersion: external-secrets.io/v1beta1
# kind: ExternalSecret
# metadata:
#   name: kargo-api-cert
#   namespace: kargo
# spec:
#   refreshInterval: "1h"
#   secretStoreRef:
#     name: scaleway
#     kind: ClusterSecretStore
#   target:
#     name: kargo-api-cert
#     creationPolicy: Owner
#   data:
#     - secretKey: tls.crt
#       remoteRef:
#         key: "${local.wildcard_certificate_crt}"
#     - secretKey: tls.key
#       remoteRef:
#         key: "${local.wildcard_certificate_key}"
# EOF
#   )
# }

# resource "kubernetes_manifest" "kargo_api_cert" {
#   depends_on = [kubernetes_manifest.wildcart_certificate_push_secret]
#   manifest = yamldecode(<<EOF
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: kargo-api-cert
#   namespace: kargo
# spec:
#   secretName: kargo-api-cert
#   issuerRef:
#     group: cert-manager.k8s.cloudflare.com
#     kind: ClusterOriginIssuer
#     name: prod-issuer
#   dnsNames:
#     - kargo-api.kargo.svc
# EOF
#   )
# }

# resource "kubernetes_manifest" "kargo_api_cert" {
#   depends_on = [kubernetes_manifest.wildcart_certificate_push_secret]
#   manifest = yamldecode(<<EOF
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: kargo-api-cert
#   namespace: kargo
# spec:
#   secretName: kargo-api-cert
#   issuerRef:
#     group: cert-manager.k8s.cloudflare.com
#     kind: ClusterOriginIssuer
#     name: prod-issuer
#   dnsNames:
#     - kargo.${var.cloudflare_domain_name}
# EOF
#   )
# }

# resource "kubernetes_manifest" "kargo_dex_server_cert" {
#   depends_on = [kubernetes_manifest.wildcart_certificate_push_secret]
#   manifest = yamldecode(<<EOF
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: kargo-dex-server-cert
#   namespace: kargo
# spec:
#   secretName: kargo-api-cert
#   issuerRef:
#     group: cert-manager.k8s.cloudflare.com
#     kind: ClusterOriginIssuer
#     name: prod-issuer
#   dnsNames:
#     - kargo-dex-server.kargo.svc
# EOF
#   )
# }
