output "vault_admin_token" {
  value     = hcp_vault_cluster_admin_token.admin.token
  sensitive = true
}

output "org_id" {
  value = data.hcp_organization.hcp_org.resource_id
}

output "proj_id" {
  value = data.hcp_project.hcp_project.resource_id
}

output "answer" {
  value = data.http.hvs_apps.response_body
}

output "url" {
  value     = data.http.hcp_api_token.url
  sensitive = true
}

output "token_response" {
  value = data.http.hcp_api_token.response_body
}