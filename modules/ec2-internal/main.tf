data "aws_region" "current" {}

#data "aws_route53_zone" "main" {
#  zone_id = "ZEHQM7JHS0Y08"
#}

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

  for_each = toset(var.number)

  #name                   = "${var.name}-${each.key}.${data.aws_route53_zone.main.name}"
  name = "${var.name}-${each.key}.its.io"

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile

  enable_volume_tags = var.enable_volume_tags
  root_block_device  = var.root_block_device

  tags = merge(
    var.tags,
    #tomap({ "Name" = "${local.client}-${local.env}-${local.role}-${each.key}.${local.domain}" })
    #tomap({ "Name" = "${var.name}-${each.key}.${data.aws_route53_zone.main.name}" })
    tomap({ "Name" = "${var.name}-${each.key}" })
    , {
      git_commit           = "052ad3ac2e9ee12416613febf92b9393b74fb6b0"
      git_file             = "modules/ec2-internal/main.tf"
      git_last_modified_at = "2023-05-26 08:12:26"
      git_last_modified_by = "dmytro@itsyndicate.org"
      git_modifiers        = "dmytro"
      git_org              = "dmytro-its"
      git_repo             = "lecture-infracost"
      yor_name             = "ec2_instance"
      yor_trace            = "ee151e8a-b42c-4f64-84dd-48852abca3ad"
  })
}
