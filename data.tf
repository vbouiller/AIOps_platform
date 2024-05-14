# HCP Data
data "hcp_organization" "hcp_org" {}

data "hcp_project" "hcp_project" {}

data "environment_sensitive_variable" "hcp_client_id" {
  name = "HCP_CLIENT_ID"
}

data "environment_sensitive_variable" "hcp_client_secret" {
  name = "HCP_CLIENT_SECRET"
}

# HTTP API Calls


data "http" "hcp_api_token" {
  url    = "https://auth.idp.hashicorp.com/oauth2/token"
  method = "POST"
  request_headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }
  request_body = "client_id=${data.environment_sensitive_variable.hcp_client_id.value}&client_secret=${data.environment_sensitive_variable.hcp_client_secret.value}&grant_type=client_credentials&audience=https://api.hashicorp.cloud"
}

locals {
  hcp_api_token = jsondecode(data.http.hcp_api_token.response_body).access_token
  hvs_base_url = "https://api.cloud.hashicorp.com/secrets/${var.hcp_api_version}/organizations/${data.hcp_organization.hcp_org.resource_id}/projects/${data.hcp_project.hcp_project.resource_id}"
}

data "http" "get_hvs_apps" {
  url    = "${local.hvs_base_url}/apps"
  method = "GET"
  request_headers = {
    Authorization = "Bearer ${local.hcp_api_token}"
  }
}