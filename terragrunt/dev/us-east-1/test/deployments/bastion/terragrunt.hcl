include "root" {
  path = find_in_parent_folders("root.terragrunt.hcl")
}

terraform {
  #source = "tfr://registry.terraform.io/terraform-aws-modules/ec2-instance/aws//.?version=4.0.0"
  source = "${get_parent_terragrunt_dir()}/../../modules//ec2-external"
}

dependency "vpc" {
  config_path                             = "../../network/vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] # Configure mock outputs for the "init", "validate", "plan", etc. commands that are returned when there are no outputs available (e.g the module hasn't been applied yet.)
  mock_outputs = {
    public_subnets = ["subnet-fake"]
    vpc_id         = "vpc_fake"
  }
}

dependency "security_group" {
  config_path                             = "../../network/sg"
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
  vpc_id    = dependency.vpc.outputs.vpc_id
  subnet_id = element(tolist(coalesce(dependency.vpc.outputs.public_subnets)), 0)
  #subnet_id = "subnet-0c2acbf82c384f58b"
  ec2_env                = local.env
  instance_type          = "t3a.large"
  vpc_security_group_ids = ["${dependency.security_group.outputs.security_group_id}"]

  ami = "ami-0ea1c7db66fee3098"

  key_name = "dmytro"

  associate_public_ip_address = true

  enable_volume_tags = false

  name = "${local.client}-${local.env}-${local.role}"

  #number = ["1"]

  role = local.role

  route53_name = "${local.client}-${local.role}"

  availability_zone = "us-east-1a"

  #proxy_address = "13.54.54.86"
  #User data - no needs at the moment
  /*   user_data = base64encode(templatefile("${path_relative_from_include()}/../../modules/lib/docker-aws-cli.sh.tpl",
    {
      region     = local.region
      role       = local.role
  }))

  user_data_replace_on_change = true */

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 125
      volume_size = 80
      tags = merge(
        tomap({ "Name" = "${local.client}-${local.env}-${local.role}-root" })
      )
    },
  ]

  tags = merge(
    tomap({ "Name" = "${local.client}-${local.env}-${local.role}.${local.domain}", "Role" = "${local.role}" })
  )
}
