data "aws_region" "current" {}

data "aws_route53_zone" "main" {
  zone_id = "ZEHQM7JHS0Y08"
}

# ----------------------------------------------------------------------------------------------------------------------
# Local Variables
# ----------------------------------------------------------------------------------------------------------------------

locals {
  prefix = var.ec2_env
  role   = var.role
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name                   = var.name

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id

  enable_volume_tags = var.enable_volume_tags
  root_block_device  = var.root_block_device

  tags = merge(
    var.tags,
    #tomap({ "Name" = "${local.client}-${local.env}-${local.role}-${each.key}.${local.domain}" })
    tomap({ "Name" = "${var.name}" })
    )
}
