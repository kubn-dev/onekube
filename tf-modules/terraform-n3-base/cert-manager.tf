locals {
  cloudflare_origin_ca_issuer_crd_version = "v0.12.1"
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "kube-system"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.17.1"
  wait       = true
  values = [templatefile("${path.module}/files/values/cert-manager.yaml", {
  })]
}

resource "kubernetes_manifest" "cluster_issuer_letsencrypt_staging" {
  manifest = yamldecode(<<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: ${var.email}
    privateKeySecretRef:
      name: letsencrypt-staging-account-key
    solvers:
      - dns01:
          cloudflare:
            apiTokenSecretRef:
              name: ${kubernetes_secret.cloudflare_api_token.metadata.0.name}
              key: ${local.cloudflare_api_token_secret_key}
EOF
  )
}

resource "kubernetes_manifest" "cluster_issuer_letsencrypt_prod" {
  manifest = yamldecode(<<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: ${var.email}
    privateKeySecretRef:
      name: letsencrypt-prod-account-key
    solvers:
      - dns01:
          cloudflare:
            apiTokenSecretRef:
              name: ${kubernetes_secret.cloudflare_api_token.metadata.0.name}
              key: ${local.cloudflare_api_token_secret_key}
EOF
  )
}

data "http" "cloudflare_originissuer_crd" {
  url = "https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/${local.cloudflare_origin_ca_issuer_crd_version}/deploy/crds/cert-manager.k8s.cloudflare.com_originissuers.yaml"
}

resource "kubectl_manifest" "cloudflare_originissuer_crd" {
  yaml_body = data.http.cloudflare_originissuer_crd.response_body
}

data "http" "cloudflare_clusteroriginissuer_crd" {
  url = "https://raw.githubusercontent.com/cloudflare/origin-ca-issuer/${local.cloudflare_origin_ca_issuer_crd_version}/deploy/crds/cert-manager.k8s.cloudflare.com_clusteroriginissuers.yaml"
}

resource "kubectl_manifest" "cloudflare_clusteroriginissuer_crd" {
  yaml_body = data.http.cloudflare_clusteroriginissuer_crd.response_body
}

resource "helm_release" "origin_ca_issuer" {
  name       = "origin-ca-issuer"
  namespace  = "kube-system"
  repository = "oci://ghcr.io/cloudflare/origin-ca-issuer-charts"
  chart      = "origin-ca-issuer"
  version    = "0.5.12"
  wait       = true
  values = [templatefile("${path.module}/files/values/origin-ca-issuer.yaml", {
  })]
}

resource "kubernetes_manifest" "clusteroriginissuer" {
  manifest = yamldecode(<<EOF
apiVersion: cert-manager.k8s.cloudflare.com/v1
kind: ClusterOriginIssuer
metadata:
  name: prod-issuer
spec:
  requestType: OriginECC
  auth:
    tokenRef:
      name: ${kubernetes_secret.cloudflare_api_token.metadata.0.name}
      key: ${local.cloudflare_api_token_secret_key}
EOF
  )
  depends_on = [kubectl_manifest.cloudflare_clusteroriginissuer_crd]
}

resource "kubernetes_manifest" "selfsignedissuer" {
  manifest = yamldecode(<<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
EOF
  )
  depends_on = [helm_release.cert_manager]
}
