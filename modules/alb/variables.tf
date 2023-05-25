variable "project" {
  description = "Project name"
  default     = "multiserver"
}

variable "AWS_SSH_KEY_NAME" {
  description = "Name of the SSH keypair to use in AWS."
  default     = "jb-itsyndicate_setup_only"
}
    ####### Network Variables ##########

variable "subnets" {
  description = "Subnets ID in VPC"
  #   type        = list(string)
}

variable "main_route53_prefix" {
  description = "Main Route53 address prefix"
  default     = ""
}

variable "vpc_id" {
  description = "Existant VPC ID"
  default     = ""
}

   ####### Security Group Variables ####


variable "security_groups" {
  description = "sec groups"
  type        = list(string)
}

   ######## Logical variables #######

variable "dns-name" {
  description = "Main domain name"
  type        = string
  default     = "jbilling.com"
}

variable "role" {
  description = "Role of instance"
}

variable "client" {
  description = "Role of instance"
}

variable "env" {
  description = "Role of instance"
}

#variable "cert_arn" {
#  description = "ARN of Certificate"
#  type = string
#}

variable "sg_for_tg" {
  description = "Security Group for detecting app instances"
  type = string
  default = "sg-09cadbaeaf858004b"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "short_client" {
  description = "Short client name"
  type =  string
  default = ""
}

variable "dns_prefix" {
  description = "Dns name"
  type =  string
  default = ""
}

variable "certificate_arn" {
  description = "SSL certificate ARN"
  default     = {}
}

### Rules variables ###

variable "priority" {
  description = "The priority for the rule between 1 and 50000. Leaving it unset will automatically set the rule with next available priority after currently existing highest rule"
  default     = null
  type        = number
}

variable "path_pattern" {
  description = "List of path patterns to match against the request URL. Maximum size of each pattern is 128 characters."
  default     = []
  type        = list(string)
}

variable "instance_group_id" {
  description = "Instances Internal SG group ID"
  type = list(string)
  default = []
}

variable "enable_http_listener" {
  description = "Enable or not ALB HTTP listener"
  type = bool
  default = false
}
