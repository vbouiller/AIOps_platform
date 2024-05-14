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
  secret_name  = "vault_token-2"
  secret_value = hcp_vault_cluster_admin_token.admin.token
}

