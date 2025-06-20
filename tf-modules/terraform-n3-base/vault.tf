resource "helm_release" "vault" {
  name       = "vault"
  namespace  = kubernetes_namespace.vault.metadata.0.name
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "v0.30.0"
  wait       = true
  values = [templatefile("${path.module}/files/values/vault.yaml", {
    host                       = "vault.${var.cloudflare_domain_name}"
    secret_name                = "vault-selfsigned-cert"
    google_project_name        = data.google_project.main.name
    google_region              = var.google_region
    google_kms_key_ring_name   = google_kms_key_ring.vault.name
    google_kms_crypto_key_name = google_kms_crypto_key.vault.name
  })]
  depends_on = [kubernetes_secret.vault_google_kms_creds]
}

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
    labels = {
      cert-type = "wildcard"
    }
  }
}

resource "kubernetes_manifest" "wildldcard_certificate_pull_secret" {
  depends_on = [kubernetes_manifest.wildcart_certificate_push_secret]
  manifest = yamldecode(<<EOF
apiVersion: external-secrets.io/v1beta1
kind: ClusterExternalSecret
metadata:
  name: ${local.wildcard_certificate_name}
spec:
  externalSecretName: ${local.wildcard_certificate_name}
  namespaceSelectors:
    - matchLabels:
        cert-type: wildcard
  refreshTime: "5m"
  externalSecretSpec:
    secretStoreRef:
      name: scaleway
      kind: ClusterSecretStore
    refreshPolicy: Periodic
    refreshInterval: "1h"
    target:
      name: ${local.wildcard_certificate_name}
      creationPolicy: Owner
    data:
      - secretKey: tls.crt
        remoteRef:
          key: "${local.wildcard_certificate_crt}"
      - secretKey: tls.key
        remoteRef:
          key: "${local.wildcard_certificate_key}"
EOF
  )
}

resource "google_service_account" "vault" {
  account_id   = "${data.google_project.main.name}-vault"
  display_name = "${data.google_project.main.name} Vault"
}

resource "google_project_iam_member" "vault" {
  project = var.google_project_id
  role    = "roles/cloudkms.admin"
  member  = google_service_account.vault.member
}

resource "google_service_account_key" "vault" {
  service_account_id = google_service_account.vault.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}

resource "google_project_service" "cloudkms" {
  service = "cloudkms.googleapis.com"
}

resource "google_kms_key_ring" "vault" {
  project    = var.google_project_id
  name       = "${data.google_project.main.name}-vault-keyring"
  location   = var.google_region
  depends_on = [google_project_service.cloudkms]
}

resource "google_kms_crypto_key" "vault" {
  name            = "${data.google_project.main.name}-vault-key"
  key_ring        = google_kms_key_ring.vault.id
  rotation_period = "100000s"
  depends_on      = [google_project_service.cloudkms]
}

resource "google_kms_key_ring_iam_binding" "vault" {
  key_ring_id = google_kms_key_ring.vault.id
  role        = "roles/owner"
  members     = [google_service_account.vault.member]
}

resource "kubernetes_secret" "vault_google_kms_creds" {
  metadata {
    name      = "google-kms-creds"
    namespace = kubernetes_namespace.vault.metadata.0.name
  }
  data = {
    key = base64decode(google_service_account_key.vault.private_key)
  }
  type = "Opaque"
}

resource "kubernetes_manifest" "vault_selfsigned_cert" {
  depends_on = [kubernetes_manifest.wildcart_certificate_push_secret]
  manifest = yamldecode(<<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: vault-selfsigned-cert
  namespace: ${kubernetes_namespace.vault.metadata.0.name}
spec:
  secretName: vault-selfsigned-cert
  duration: 2160h
  renewBefore: 360h
  issuerRef:
    name: selfsigned-issuer
    kind: ClusterIssuer
  dnsNames:
    - vault-0.vault-internal
    - vault-1.vault-internal
    - vault-2.vault-internal
  ipAddresses:
    - 127.0.0.1
EOF
  )
}
