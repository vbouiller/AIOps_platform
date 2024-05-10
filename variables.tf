# HVN variables

variable "hvn_cloud_provider" {
  description = "HVN cloud provider, defaults to 'aws'"
  type = string
  default = "aws"
}

variable "hvn_region" {
  description = "HVN region, defaults to eu-central-1"
  type = string
  default = "eu-central-1"
}

variable "hvn_id" {
  description = "HVN name"
  type = string
  default = "platform-hvn"
}

# VAULT variables

variable "vault_id" {
    description = "Vault cluster name"
    type = string
    default = "platform-vault"
}

variable "vault_tier" {
  description = "Tier of the HCP Vault cluster"
  type = string
  default = "plus_small"
}