output "vault_admin_token" {
  value     = hcp_vault_cluster_admin_token.admin.token
  sensitive = true
}

output "answer" {
  value = data.http.hvs_apps.response_body
}

output "auth" {
  value     = data.http.hvs_apps.request_headers
  sensitive = true
}

output "url" {
  value     = data.http.hvs_apps.url
  sensitive = true
}