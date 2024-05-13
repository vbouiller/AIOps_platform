output "vault_admin_token" {
  value     = hcp_vault_cluster_admin_token.admin.token
  sensitive = true
}

output "answer" {
  value = data.http.hvs_apps.response_body
}

output "token" {
    value = jsondecode(data.http.hcp_api_token.response_body).access_token
}