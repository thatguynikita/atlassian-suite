data "aws_iam_instance_profile" "ec2-access" {
  name = "${var.iam_instance_profile_name}"
}

data "aws_ami" "amazonlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]
}

resource "aws_launch_configuration" "bitbucket" {
  image_id                    = "${data.aws_ami.amazonlinux2.id}"
  instance_type               = "${var.bitbucket_instance_type}"
  associate_public_ip_address = false
  name                        = "atlassian_bitbucket_lc"
  iam_instance_profile        = "${data.aws_iam_instance_profile.ec2-access.name}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.bitbucket}"]
  user_data                   = ""

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

resource "aws_launch_configuration" "jira" {
  image_id                    = "${data.aws_ami.amazonlinux2.id}"
  instance_type               = "${var.jira_instance_type}"
  associate_public_ip_address = false
  name                        = "atlassian_jira_lc"
  iam_instance_profile        = "${data.aws_iam_instance_profile.ec2-access.name}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.jira}"]
  user_data                   = ""

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

resource "aws_launch_configuration" "confluence" {
  image_id                    = "${data.aws_ami.amazonlinux2.id}"
  instance_type               = "${var.confluence_instance_type}"
  associate_public_ip_address = false
  name                        = "atlassian_confluence_lc"
  iam_instance_profile        = "${data.aws_iam_instance_profile.ec2-access.name}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.confluence}"]
  user_data                   = ""

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}

resource "aws_ebs_volume" "bitbucket" {
  availability_zone = "${data.aws_subnet.private.availability_zone}"
  size              = "${var.bitbucket_volume_size}"
  type              = "gp2"

  tags {
    Name = "Bitbucket server"
  }
}

resource "aws_ebs_volume" "jira" {
  availability_zone = "${data.aws_subnet.private.availability_zone}"
  size              = "${var.jira_volume_size}"
  type              = "gp2"

  tags {
    Name = "Jira server"
  }
}

resource "aws_ebs_volume" "confluence" {
  availability_zone = "${data.aws_subnet.private.availability_zone}"
  size              = "${var.confluence_volume_size}"
  type              = "gp2"

  tags {
    Name = "Confluence server"
  }
}

resource "aws_db_instance" "postgresdb" {
  instance_class         = "${var.postgres_instance_class}"
  allocated_storage      = "${var.postgres_allocated_storage}"
  engine                 = "postgres"
  storage_type           = "gp2"
  identifier             = "atlassian-suite"
  username               = "${var.postgres_db_username}"
  password               = "${var.postgres_db_password}"
  vpc_security_group_ids = ["${aws_security_group.postgresdb.id}"]
  db_subnet_group_name   = "${var.rds_subnet_group_name}"

  tags {
    Name = "DB for Atlassian suite"
  }
}
