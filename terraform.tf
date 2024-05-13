terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }

    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.88.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.25.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.2"
    }

    environment = {
      source  = "MorganPeat/environment"
      version = "0.2.6"
    }

  }
}


provider "hcp" {}

provider "vault" {
  address   = hcp_vault_cluster.vault.public_endpoint
  token     = hcp_vault_cluster_admin_token.admin.token
  namespace = var.vault_namespace
}

provider "http" {}