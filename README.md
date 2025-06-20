# onekube

One-ring-to-rules-them-all K8s Cluster setup.

## Architecture

* Domain Registrar (DNS) and SSL/TLS certificates managed in Cloudflare
* Managed Kubernetes cluster hosted in Scaleway
* OAuth Authentication Provider by Google

## Get-Started

Provision all variables in `.env.local` file with values retrieved from the cloud providers.

### Cloudflare

* [Create a Cloudflare account](https://www.cloudflare.com/plans/)
* Retrieve "Account ID", "API Key" and "Account Email"
* Register a domain name and retrieve "Zone ID"
* Generate an API Token with permissions: "All zones - Zone:Read, SSL and Certificates:Edit, DNS:Edit
* Change the the "SSL/TLS encryption" mode to "Full (strict)" to the entire flow Browser <> Cloudflare <> Origin server is encrypted

### Google Cloud Platform

Terraform states are managed in the cloud using a bucket in Google Cloud Storage, this requiring a GCP account. To authentication using the `gcloud` tool, simply run `gcloud auth application-default login` and follow the instructions.

### Scaleway

* [Create a Scaleway account](https://account.scaleway.com/register)
* Create an Organization and retrieve the "Organization ID"
* Create an Identity and Access Management (IAM) key and retrieve "Access Key" and "Secret Key"
* Create a Project and retrieve the "Project ID"
* Create a VPC and retrieve "VPC ID", "Region", "Zone"

### Install tooling

* [Install Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
* [Install Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
* [Install Scaleway CLI](https://github.com/scaleway/scaleway-cli) and [set it up](https://www.scaleway.com/en/docs/scaleway-cli/quickstart/)
* [Install `gcloud` CLI](https://cloud.google.com/sdk/docs/install) and [set it up](https://cloud.google.com/sdk/docs/initializing)

## Instantiate

```bash
source .env.local
terragrunt apply
```