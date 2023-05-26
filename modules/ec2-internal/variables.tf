variable "ami" {
  description = "AMI for ec2"
}

variable "instance_type" {
  description = "EC2 type"
}

variable "key_name" {
  description = "SSH key used for instance craetion"
}

variable "vpc_security_group_ids" {
  description = "Security group IDS"
  type        = list(any)
}

variable "subnet_id" {
  description = "Subnets IDs"
}

variable "ec2_env" {
  description = "Environment"
}

variable "root_block_device" {
  description = "Data for root device"
  type        = list(any)
}

variable "enable_volume_tags" {
  description = "Variable for the volume tags"
  type        = bool
}

variable "name" {
  description = "Name of instance"
}

variable "number" {
  description = "Number of instances by list"
  type = list(string)
  default =  []
}

variable "role" {
  description = "Role of instance"
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type = string
  default = ""
}
/*
variable "route53_name" {
  description = "DNS record for ec2"
}

variable "proxy_address" {
  description = "IP address of proxy for behind-bastion instances"

}
*/
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
