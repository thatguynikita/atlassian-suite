####
#   Main section
####

variable "aws_region" {
  description = "AWS region to use"
  default     = "eu-central-1"
}

variable "profile" {
  description = "AWS profile used for deployment"
  default     = "default"
}

variable "key_name" {
  description = "Name of the public key to install on EC2 instances"
}

####
#   Site related
####

variable "vpc_id" {
  description = "VPC ID to launch instances in"
}

variable "private_app_subnets" {
  description = "Private subnet ID(s) for application deployments"
  type = "list"
}

variable "private_db_subnets" {
  description = "Private subnet IDs for DB instance. At least 2 is required to make DB subnet group"
  type = "list"
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

variable "bitbucket_url" {}

####
#   Jira instance
####

variable "jira_instance_type" {
  default = "t2.small"
}

variable "jira_volume_size" {
  default = 10
}

variable "jira_url" {}

####
#   Confluence instance
####

variable "confluence_instance_type" {
  default = "t2.medium"
}

variable "confluence_volume_size" {
  default = 10
}

variable "confluence_url" {}

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
