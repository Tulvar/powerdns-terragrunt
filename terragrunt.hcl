locals {
  state_path = basename(path_relative_to_include())
  domen_vars = yamldecode(file("${get_parent_terragrunt_dir()}/zones/domen/domen.yml"))
  example_vars = yamldecode(file("${get_parent_terragrunt_dir()}/zones/example/example.yml"))
}

inputs = {
    pdns_api_key    = "SECRET_API_KEY"
    dns_records_map = merge(local.domen_vars.dns_records_map, local.example_vars.dns_records_map)
}

remote_state {
  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  backend = "local"
  config = {
    path = "${get_parent_terragrunt_dir()}/terraform.tfstate"
  }
}

// Block for Gitlab HTTP backend
// remote_state {
//   generate = {
//     path      = "_backend.tf"
//     if_exists = "overwrite"
//   }
//   backend = "http"
//   config = {
//     address        = format("%s/projects/%s/terraform/state/%s", get_env("CI_API_V4_URL", ""), get_env("CI_PROJECT_ID", ""), local.state_path)
//     lock_address   = format("%s/projects/%s/terraform/state/%s/lock", get_env("CI_API_V4_URL", ""), get_env("CI_PROJECT_ID", ""), local.state_path)
//     unlock_address = format("%s/projects/%s/terraform/state/%s/lock", get_env("CI_API_V4_URL", ""), get_env("CI_PROJECT_ID", ""), local.state_path)
//     retry_max      = "3"
//     unlock_method  = "DELETE"
//     lock_method    = "POST"
//     retry_wait_min = "5"
//   }
// }


generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOL
terraform {
  required_providers {
    powerdns = {
      source = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}
EOL
}
