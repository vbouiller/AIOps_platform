# Global suffix

resource "random_pet" "suffix" {
  length = 2
}

# HVN settings

resource "hcp_hvn" "hvn" {
  hvn_id         = "${var.hvn_id}-${random_pet.suffix.id}"
  cloud_provider = var.hvn_cloud_provider
  region         = var.hvn_region
}

# Platform settings

resource "hcp_vault_cluster" "vault" {
  cluster_id      = "${var.vault_id}-${random_pet.suffix.id}"
  hvn_id          = hcp_hvn.hvn.hvn_id
  tier            = var.vault_tier
  public_endpoint = var.public_endpoint
}

resource "hcp_vault_cluster_admin_token" "admin" {
  cluster_id = hcp_vault_cluster.vault.cluster_id
}

resource "hcp_vault_secrets_app" "github_syns" {
  app_name    = var.hvs_app_name
  description = "test"
}

resource "hcp_vault_secrets_secret" "vault_token" {
  app_name     = hcp_vault_secrets_app.github_syns.app_name
  secret_name  = "vault_token"
  secret_value = hcp_vault_cluster_admin_token.admin.token
}


data "http" "hcp_api_token" {
  url    = "https://auth.idp.hashicorp.com/oauth2/toke?${local.token_client_id}&${local.token_client_secret}&${local.token_end_url}"
  method = "GET"
  request_headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }
}

data "http" "hvs_apps" {
  url    = "https://api.cloud.hashicorp.com/secrets/2023-06-13/organizations/${data.hcp_organization.org.resource_id}/projects/${data.hcp_project.project.resource_id}/apps}"
  method = "GET"

  request_headers = {
    "Authorization" = "Bearer ${data.http.hcp_api_token.response_body}"
  }
}

locals {
  token_client_id     = urlencode("client_id=${data.environment_sensitive_variable.hcp_client_id}")
  token_client_secret = urlencode("client_secret=${data.environment_sensitive_variable.hcp_client_secret}")
  token_end_url       = urlencode("grant_type=client_credentials&audience=https://api.hashicorp.cloud")
}