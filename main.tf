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

# Vault settings

resource "hcp_vault_cluster" "vault" {
  cluster_id      = "${var.vault_id}-${random_pet.suffix.id}"
  hvn_id          = hcp_hvn.hvn.hvn_id
  tier            = var.vault_tier
  public_endpoint = var.public_endpoint
}

## Vault Azure Auth
resource "vault_auth_backend" "azure" {
  type        = "azure"
  description = "Azure auth method for Vault's agent auto-auth"
}
resource "vault_azure_auth_backend_config" "agent" {
  backend = vault_auth_backend.azure.path

  tenant_id     = data.environment_variable.azure_tenant_id.value
  client_id     = data.environment_variable.azure_client_id.value
  client_secret = data.environment_sensitive_variable.azure_client_secret.value
  resource      = "https://management.azure.com/"
}

resource "vault_azure_auth_backend_role" "agent" {
  backend = vault_auth_backend.azure.path

  role                   = "agent"
  token_policies         = ["default", "agent"]
  bound_subscription_ids = [data.environment_variable.azure_subscription_id.value]
}

## Vault SSH Secret Engine

resource "vault_mount" "ssh" {
  type        = "ssh"
  path        = "ssh-client-signer"
  description = "SSH Secret Engine"
}

resource "vault_ssh_secret_backend_ca" "ssh-ca" {
  backend              = vault_mount.ssh.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "ca-signer" {
  name                    = "ca-sign"
  backend                 = vault_mount.ssh.path
  key_type                = "ca"
  allow_user_certificates = true
  allowed_users           = "*"
  default_extensions = {
    "permit-pty" = ""
  }
}

## Vault KV Secret Engine

resource "vault_mount" "kvv2" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KVv2 for Datadog & openai information"
}

resource "vault_kv_secret_v2" "dd" {
  mount               = vault_mount.kvv2.path
  name                = "dd"
  delete_all_versions = true
  data_json = jsonencode(
    {
      apikey = data.environment_sensitive_variable.dd_apikey.value
    }
  )
}

## Vault Policies
resource "vault_policy" "agent" {
  name   = "agent"
  policy = <<EOT
path "kv/data/openai" {
    capabilities = ["read"]
}
EOT
}

resource "hcp_vault_cluster_admin_token" "admin" {
  cluster_id = hcp_vault_cluster.vault.cluster_id
}

# HVS App & secret
resource "hcp_vault_secrets_app" "github_syns" {
  app_name    = var.hvs_app_name
  description = "test"
}

resource "hcp_vault_secrets_secret" "vault_token" {
  app_name     = hcp_vault_secrets_app.github_syns.app_name
  secret_name  = "vault_token"
  secret_value = hcp_vault_cluster_admin_token.admin.token
}