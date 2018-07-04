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
  description = "EC2 instance type"
  default = "t2.medium"
}

variable "bitbucket_volume_size" {
  description = "Attached EBS volume size"
  default = 10
}

variable "bitbucket_url" {
  description = "Internet facing URL"
}

####
#   Jira instance
####

variable "jira_instance_type" {
  description = "EC2 instance type"
  default = "t2.small"
}

variable "jira_volume_size" {
  description = "Attached EBS volume size"
  default = 10
}

variable "jira_url" {
  description = "Internet facing URL"
}

####
#   Confluence instance
####

variable "confluence_instance_type" {
  description = "EC2 instance type"
  default = "t2.medium"
}

variable "confluence_volume_size" {
  description = "Attached EBS volume size"
  default = 10
}

variable "confluence_url" {
  description = "Internet facing URL"
}

####
#   RDS instance
####

variable "db_instance_class" {
  description = "RDS instance type"
  default = "db.t2.micro"
}

variable "db_engine" {
  description = "DB engine to use"
  default = "postgres"
}

variable "db_allocated_storage" {
  description = "Amount of storage to allocate"
  default = 10
}

variable "db_username" {
  description = "DB username"
}

variable "db_password" {
  description = "DB password"
}
