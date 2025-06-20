resource "helm_release" "external_secrets_operator" {
  name       = "external-secrets-operator"
  namespace  = "kube-system"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "v0.16.1"
  wait       = true
  values = [templatefile("${path.module}/files/values/external-secrets-operator.yaml", {
  })]
}

resource "scaleway_iam_application" "main" {
  name        = var.scw_project_id
  description = var.scw_project_id
}

resource "scaleway_iam_policy" "main" {
  name           = "${var.scw_project_id}-external-secrets-operator"
  description    = "Read-write access to the Secrets Manager"
  application_id = scaleway_iam_application.main.id
  rule {
    project_ids          = [var.scw_project_id]
    permission_set_names = ["SecretManagerFullAccess"]
  }
}

resource "scaleway_iam_api_key" "main" {
  description    = "API key for External Secrets Operator"
  application_id = scaleway_iam_application.main.id
}

resource "kubernetes_secret" "scaleway_api_key" {
  metadata {
    name      = "scaleway-api-key"
    namespace = "kube-system"
  }
  data = {
    access_key = scaleway_iam_api_key.main.access_key
    secret_key = scaleway_iam_api_key.main.secret_key
  }
  type = "Opaque"
}

resource "kubernetes_manifest" "external_secrets_operator" {
  depends_on = [helm_release.external_secrets_operator]
  manifest = yamldecode(<<EOF
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: scaleway
spec:
  provider:
    scaleway:
      region: ${var.scw_region}
      projectId: ${var.scw_project_id}
      accessKey:
        secretRef:
          namespace: kube-system
          name: ${kubernetes_secret.scaleway_api_key.metadata.0.name}
          key: access_key
      secretKey:
        secretRef:
          namespace: kube-system
          name: ${kubernetes_secret.scaleway_api_key.metadata.0.name}
          key: secret_key
EOF
  )
}
