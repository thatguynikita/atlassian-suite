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

resource "aws_launch_configuration" "application" {
  image_id                    = "${data.aws_ami.amazonlinux2.id}"
  instance_type               = "${var.app_instance_type}"
  associate_public_ip_address = false
  name                        = "${var.tag}"
  iam_instance_profile        = "${var.iam_instance_profile_name}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.application}"]
  user_data                   = "${file("user-data.sh")}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
  }
}