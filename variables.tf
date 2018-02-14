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
  description = ""
}

variable "private_subnet_name" {
  description = "Private subnet name to deploy our Atlassian instances in"
}

variable "rds_subnet_group_name" {
  description = "DB subnet group name for RDS instance"
}

####
#   Bitbucket instance
####

variable "bitbucket_instance_type" {
  default = "t2.micro"
}

variable "bitbucket_volume_size" {}

####
#   Jira instance
####

variable "jira_instance_type" {
  default = "t2.micro"
}

variable "jira_volume_size" {}

####
#   Confluence instance
####

variable "confluence_instance_type" {
  default = "t2.micro"
}

variable "confluence_volume_size" {}

####
#   RDS instance
####

variable "postgres_instance_class" {
  default = "db.t2.micro"
}

variable "postgres_allocated_storage" {}

variable "postgres_db_username" {}

variable "postgres_db_password" {}
