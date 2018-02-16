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

# Read only role for EC2 instances
resource "aws_iam_role_policy" "ec2_readonly" {
  name = "atlassian-ec2-readonly"
  role = "${aws_iam_role.ec2_assume_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ec2_assume_role" {
  name = "atlassian-ec2-readonly"
  description = "Read only role for EC2 instances to run Ansible ec2-gather-facts"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "atlassian-ec2-readonly"
  role = "${aws_iam_role.ec2_assume_role.name}"
}

module "postgres" {
  source          = "./data-storage"
  name_tag        = "atlassian-postgres"
  vpc_id          = "${var.vpc_id}"
  private_subnets = "${var.private_db_subnets}"
  open_port_range = ["5432", "5432"]

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
  open_port_range           = ["7990", "7990"]
  iam_instance_profile_name = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name                  = "${var.key_name}"
  instance_type             = "${var.bitbucket_instance_type}"
  home_volume_size          = "${var.bitbucket_volume_size}"
  db_endpoint               = "${module.postgres.endpoint}"
}

module "jira_instance" {
  source                    = "./application"
  name_tag                  = "atlassian-jira"
  vpc_id                    = "${var.vpc_id}"
  private_subnet            = "${var.private_app_subnets[1]}"
  open_port_range           = ["8080", "8080"]
  iam_instance_profile_name = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name                  = "${var.key_name}"
  instance_type             = "${var.jira_instance_type}"
  home_volume_size          = "${var.jira_volume_size}"
  db_endpoint               = "${module.postgres.endpoint}"
}

module "confluence_instance" {
  source                    = "./application"
  name_tag                  = "atlassian-confluence"
  vpc_id                    = "${var.vpc_id}"
  private_subnet            = "${var.private_app_subnets[1]}"
  open_port_range           = ["8090", "8091"]
  iam_instance_profile_name = "${aws_iam_instance_profile.ec2_instance_profile.name}"
  key_name                  = "${var.key_name}"
  instance_type             = "${var.confluence_instance_type}"
  home_volume_size          = "${var.confluence_volume_size}"
  db_endpoint               = "${module.postgres.endpoint}"
}
