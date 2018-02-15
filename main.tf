provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}

terraform {
  backend "s3" {
    bucket  = "${var.backend_bucket}"
    key     = "${var.backend_path}"
    region  = "${var.backend_region}"
    encrypt = true
  }
}

## Test destroy too

module "bitbucket" {
  source                    = "./application"
  vpc_name                  = "${var.vpc_name}"
  private_subnet            = "${var.private_app_subnets[0]}"
  open_port_range           = ["7990", "7990"]
  tag                       = "atlassian-bitbucket"
  iam_instance_profile_name = "${var.iam_instance_profile_name}"
  key_name                  = "${var.key_name}"
  app_instance_type         = "${var.bitbucket_instance_type}"
  home_volume_size          = "${var.bitbucket_volume_size}"
}

module "jira" {
  source                    = "./application"
  vpc_name                  = "${var.vpc_name}"
  private_subnet            = "${var.private_app_subnets[1]}"
  open_port_range           = ["8080", "8080"]
  tag                       = "atlassian-jira"
  iam_instance_profile_name = "${var.iam_instance_profile_name}"
  key_name                  = "${var.key_name}"
  app_instance_type         = "${var.jira_instance_type}"
  home_volume_size          = "${var.jira_volume_size}"
}

module "confluence" {
  source                    = "./application"
  vpc_name                  = "${var.vpc_name}"
  private_subnet            = "${var.private_app_subnets[1]}"
  open_port_range           = ["8090", "8091"]
  tag                       = "atlassian-confluence"
  iam_instance_profile_name = "${var.iam_instance_profile_name}"
  key_name                  = "${var.key_name}"
  app_instance_type         = "${var.confluence_instance_type}"
  home_volume_size          = "${var.confluence_volume_size}"
}

module "postgres" {
  source            = "./data-storage"
  vpc_name          = "${var.vpc_name}"
  private_subnets   = "${var.private_db_subnets}"
  open_port_range   = ["5432", "5432"]
  tag               = "atlassian-postgres"
  instance_class    = "${var.db_instance_class}"
  engine            = "${var.db_engine}"
  allocated_storage = "${var.db_allocated_storage}"
  username          = "${var.db_username}"
  password          = "${var.db_password}"

  allowed_sgs = [
    "${module.bitbucket.security_group_id}",
    "${module.jira.security_group_id}",
    "${module.confluence.security_group_id}",
  ]
}
