include "root" {
  path = find_in_parent_folders("root.terragrunt.hcl")
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws//.?version=3.18.1"
}


locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  client_vars      = read_terragrunt_config(find_in_parent_folders("client.hcl"))
  # Extract out common variables for reuse
  project = local.environment_vars.locals.project
  #env     = "staging"
  client = local.client_vars.locals.client
  env    = local.environment_vars.locals.environment
  name   = "${local.client}-${local.env}-VPC"
  #default_acls = include.network_acls.default_acls
  default_acls = read_terragrunt_config("network_acls_default.hcl")
  public_acls  = read_terragrunt_config("network_acls_public.hcl")
  private_acls = read_terragrunt_config("network_acls_private.hcl")
  network_acls = merge(
    local.default_acls.inputs,
    local.public_acls.inputs,
    local.private_acls.inputs,
    {

  })
}

inputs = {
  namespace   = local.project
  environment = local.env
  name        = "${local.client}-${local.env}-VPC"
  cidr        = "172.17.0.0/16"

  azs                          = ["us-east-1a", "us-east-1b"]
  create_database_subnet_group = true
  database_subnet_group_name   = "${local.client}-${local.env}-DB-group"
  create_igw                   = true

  public_subnets   = ["172.17.10.0/25", "172.17.10.128/25"]
  private_subnets  = ["172.17.11.0/25"]
  database_subnets = ["172.17.12.0/25", "172.17.12.128/25"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  single_nat_gateway = true

  public_dedicated_network_acl = true
  public_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["public_inbound"])
  public_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["public_outbound"])

  private_dedicated_network_acl = true
  private_inbound_acl_rules     = concat(local.network_acls["default_inbound"], local.network_acls["private_inbound"])
  private_outbound_acl_rules    = concat(local.network_acls["default_outbound"], local.network_acls["private_outbound"])

  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  public_subnet_tags = { Role = "public" }

  enable_dns_hostnames = true


  manage_default_network_acl     = true
  database_dedicated_network_acl = true
  database_inbound_acl_rules = [
    {
      "cidr_block" : "172.17.0.0/16",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 0
    }
  ]

  database_outbound_acl_rules = [
    {
      "cidr_block" : "172.17.0.0/16",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 0
    }
  ]
}
