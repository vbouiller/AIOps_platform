output "vault_admin_token" {
  value     = hcp_vault_cluster_admin_token.admin.token
  sensitive = true
}

output "answer" {
  value = jsondecode(data.http.get_hvs_apps.response_body).apps[*].name
}