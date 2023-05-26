include "root" {
  path = find_in_parent_folders("root.terragrunt.hcl")
}
/*
terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/alb/aws//.?version=8.2.1"
}
*/

terraform {
  source = "${get_parent_terragrunt_dir()}/../../modules//alb/"
}

dependency "vpc" {
  config_path                             = "../../network/vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] # Configure mock outputs for the "init", "validate", "plan", etc. commands that are returned when there are no outputs available (e.g the module hasn't been applied yet.)
  mock_outputs = {
    public_subnets = ["subnet-fake"]
    vpc_id         = "vpc_id"
  }
}

dependency "security_group" {
  config_path                             = "../../network/sg/"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"]
  mock_outputs = {
    security_group_id = "sg-fake-id"
  }
}


locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  role_var         = read_terragrunt_config("role.hcl")
  client_vars      = read_terragrunt_config(find_in_parent_folders("client.hcl"))

  # Extract out common variables for reuse
  project = local.environment_vars.locals.project
  env     = local.environment_vars.locals.environment
  domain  = local.environment_vars.locals.domain
  client  = local.client_vars.locals.client
  role    = local.role_var.locals.role
  region  = local.region_vars.locals.aws_region
}

inputs = {

  name                  = "${local.client}-${local.env}-${local.role}"
  description           = "ALB for ${local.client}-${local.env}"
  namespace             = local.project
  env                   = local.env
  client                = local.client_vars.locals.client
  short_client          = local.client_vars.locals.short_client
  role                  = local.role
  dns_prefix            = "test"
  dns-name              = "its.io"
  enable_http_listener  = true
  enable_https_listener = false

  load_balancer_type = "application"

  vpc_id          = dependency.vpc.outputs.vpc_id
  subnets         = ["${dependency.vpc.outputs.public_subnets}"]
  security_groups = ["${dependency.security_group.outputs.security_group_id}"]
  #security_groups   = concat(["${dependency.external_security_group.outputs.security_group_id}"], ["${dependency.internal_security_group.outputs.security_group_id}"], ["${dependency.whitelisted_ips_security_group.outputs.security_group_id}"])
  instance_group_id = ["${dependency.security_group.outputs.security_group_id}"]
  certificate_arn   = "arn:aws:acm:us-east-1:448058496623:certificate/03cca9c6-df8a-41ee-af4a-0dfe89705c55"
}
