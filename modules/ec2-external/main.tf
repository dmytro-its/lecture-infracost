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

  name = var.name

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
    , {
      git_commit           = "cd9cf36061b2576cf99007215aa13f575888e2de"
      git_file             = "modules/ec2-external/main.tf"
      git_last_modified_at = "2023-05-25 09:08:21"
      git_last_modified_by = "dmytro@itsyndicate.org"
      git_modifiers        = "dmytro"
      git_org              = "dmytro-its"
      git_repo             = "lecture-infracost"
      yor_name             = "ec2_instance"
      yor_trace            = "4e333bf3-548f-48b0-b6f4-02fefe816848"
  })
}
