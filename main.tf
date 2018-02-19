provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}

#terraform {
#  backend "s3" {
#    bucket  = "${var.backend_bucket}"
#    key     = "${var.backend_path}"
#    region  = "${var.backend_region}"
#    encrypt = true
#  }
#}
## Test destroy too

module "postgres" {
  source          = "./data-storage"
  name_tag        = "atlassian-postgres"
  vpc_id          = "${var.vpc_id}"
  private_subnets = "${var.private_db_subnets}"
  listening_port  = "5432"

  allowed_sgs = [
    "${module.bitbucket_instance.security_group_id}",
    "${module.jira_instance.security_group_id}",
    "${module.confluence_instance.security_group_id}",
  ]

  instance_class    = "${var.db_instance_class}"
  engine            = "${var.db_engine}"
  allocated_storage = "${var.db_allocated_storage}"
  username          = "${var.db_username}"
  password          = "${var.db_password}"
}

module "bitbucket_instance" {
  source                    = "./application"
  name_tag                  = "atlassian-bitbucket"
  vpc_id                    = "${var.vpc_id}"
  private_subnet            = "${var.private_app_subnets[0]}"
  listening_port            = "7990"
  iam_instance_profile_name = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name                  = "${var.key_name}"
  instance_type             = "${var.bitbucket_instance_type}"
  home_volume_size          = "${var.bitbucket_volume_size}"
  db_endpoint               = "${module.postgres.endpoint}"
  db_credentials            = ["${var.db_username}", "${var.db_password}"]
  ansible_playbook          = "playbook/bitbucket.yml"
  website_url               = "${var.bitbucket_url}"
}

module "jira_instance" {
  source                    = "./application"
  name_tag                  = "atlassian-jira"
  vpc_id                    = "${var.vpc_id}"
  private_subnet            = "${var.private_app_subnets[1]}"
  listening_port            = "8080"
  iam_instance_profile_name = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name                  = "${var.key_name}"
  instance_type             = "${var.jira_instance_type}"
  home_volume_size          = "${var.jira_volume_size}"
  db_endpoint               = "${module.postgres.endpoint}"
  db_credentials            = ["${var.db_username}", "${var.db_password}"]
  ansible_playbook          = "playbook/jira.yml"
  website_url               = "${var.jira_url}"
}

module "confluence_instance" {
  source                    = "./application"
  name_tag                  = "atlassian-confluence"
  vpc_id                    = "${var.vpc_id}"
  private_subnet            = "${var.private_app_subnets[1]}"
  listening_port            = "8090"
  iam_instance_profile_name = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name                  = "${var.key_name}"
  instance_type             = "${var.confluence_instance_type}"
  home_volume_size          = "${var.confluence_volume_size}"
  db_endpoint               = "${module.postgres.endpoint}"
  db_credentials            = ["${var.db_username}", "${var.db_password}"]
  ansible_playbook          = "playbook/confluence.yml"
  website_url               = "${var.confluence_url}"
}
