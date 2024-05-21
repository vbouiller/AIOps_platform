output "vault_admin_token" {
  value     = hcp_vault_cluster_admin_token.admin.token
  sensitive = true
}

output "vault_cluster_adress" {
  value = hcp_vault_cluster.vault.public_endpoint
}

output "vault_cluster_namespace" {
  value = hcp_vault_cluster.vault.namespace
}

output "answer" {
  value = jsondecode(data.http.get_hvs_apps.response_body).apps[*].name
}