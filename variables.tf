####
#   Main section
####

variable "aws_region" {
  description = "AWS region to use"
  default     = "eu-central-1"
}

variable "profile" {
  description = "AWS profile to use for deployment"
}

variable "key_name" {
  description = "Name of the publice key to install"
}

variable "iam_instance_profile_name" {
  description = "IAM profile name with read access to EC2 instances. Required to call Ansible gather facts"
}

# S3 backend path to store tfstate file
variable "backend_bucket" {}

variable "backend_path" {}

variable "backend_region" {}

####
#   Network related
####

variable "vpc_name" {
  description = "Name of the VPC to launch instances in"
}

variable "private_app_subnets" {
  description = "Private subnet name tag to deploy our Atlassian instances. Specify at least 2"
  type = list
}

variable "private_db_subnets" {
  description = "Private subnet name tag to deploy our DB instance. Specify at least 2"
  type = list
}

####
#   Bitbucket instance
####

variable "bitbucket_instance_type" {
  default = "t2.medium"
}

variable "bitbucket_volume_size" {
  default = 10
}

####
#   Jira instance
####

variable "jira_instance_type" {
  default = "t2.micro"
}

variable "jira_volume_size" {
  default = 10
}

####
#   Confluence instance
####

variable "confluence_instance_type" {
  default = "t2.small"
}

variable "confluence_volume_size" {
  default = 10
}

####
#   RDS instance
####

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "db_engine" {
  default = "postgres"
}

variable "db_allocated_storage" {
  default = 10
}

variable "db_username" {}

variable "db_password" {}
