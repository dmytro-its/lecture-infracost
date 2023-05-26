# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Define root dir
  root_env_dir = get_parent_terragrunt_dir()
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  #region_vars = read_terragrunt_config("region.hcl")
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  #environment_vars = read_terragrunt_config("env.hcl")
  client_vars = read_terragrunt_config(find_in_parent_folders("client.hcl"))
  # Extract the variables we need for easy access
  aws_region   = local.region_vars.locals.aws_region
  env          = local.environment_vars.locals.environment
  client       = local.client_vars.locals.client
  short_region = local.region_vars.locals.short_region
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "= 4.67.0"
    }
  }
}
  provider "aws" {
    region = "${local.aws_region}"
  }
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt = true
    #bucket  = "terragrunt-${local.short_region}/${local.client}/${local.env}/"
    bucket         = "terragrunt-${local.short_region}-${local.client}-${local.env}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.aws_region}"
    encrypt        = true
    dynamodb_table = "terragrunt-state-lock-us"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
#
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals,
)
