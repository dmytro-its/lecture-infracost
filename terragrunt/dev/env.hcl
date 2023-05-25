locals {
  project     = "lecture"
  environment = "dev"
  client      = "ITS"
  domain      = "its.io"
  tags = {
    Environment = "develop"
    Project     = "Lecture"
    DevOps      = "devops@itsyndicate.org"
    ManagedBy   = "Terraform - Only IaC Changes"
    group       = "ITS"
    team        = "ITS"
  }
}
