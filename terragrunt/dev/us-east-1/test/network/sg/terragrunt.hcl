terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/security-group/aws//.?version=4.16.2"
}

include "root" {
  path = find_in_parent_folders("root.terragrunt.hcl")
}

dependency "vpc" {
  config_path                             = "../vpc/"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] # Configure mock outputs for the "init", "validate", "plan", etc. commands that are returned when there are no outputs available (e.g the module hasn't been applied yet.)
  mock_outputs = {
    vpc_id                      = "vpc-fake-id"
    private_subnets             = ["10.1.0.0/16"]
    public_subnets              = ["32.0.0.0/16"]
    private_subnets_cidr_blocks = ["10.1.0.0/16"]
  }
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  project     = local.environment_vars.locals.project
  env         = local.environment_vars.locals.environment
  client_vars = read_terragrunt_config(find_in_parent_folders("client.hcl"))
}

inputs = {

  name         = "${local.client_vars.locals.short_client}-${local.env}-external-sg"
  description  = "Security group for ${local.client_vars.locals.client}-${local.env}"
  vpc_id       = dependency.vpc.outputs.vpc_id
  namespace    = local.project
  environment  = local.env
  client       = local.client_vars.locals.client
  short_client = local.client_vars.locals.short_client
  subnets_ids  = ["${dependency.vpc.outputs.private_subnets}", "${dependency.vpc.outputs.public_subnets}"]


  ingress_cidr_blocks = "${dependency.vpc.outputs.private_subnets_cidr_blocks}"
  ingress_rules       = ["https-443-tcp"]

  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "82.196.6.227/32"
      description = "ITSyndicate"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = "52.71.119.166/32"
    },
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Rule for HTTPS access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Rule for HTTP access"
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]

  egress_with_cidr_blocks = [
    {
      rule = "all-all"
    }

  ]

}
