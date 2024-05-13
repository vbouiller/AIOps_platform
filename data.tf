# HCP Data
data "hcp_organization" "hcp_org" {}

data "hcp_project" "hcp_project" {}

data "environment_sensitive_variable" "hcp_client_id" {
  name = "HCP_CLIENT_ID"
}

data "environment_sensitive_variable" "hcp_client_secret" {
  name = "HCP_CLIENT_SECRET"
}
