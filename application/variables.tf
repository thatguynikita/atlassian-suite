data "aws_vpc" "site_vpc" {
  state = "available"

  tags {
    Name = "${var.vpc_name}"
  }
}

data "aws_subnet" "private" {
  vpc_id = "${data.aws_vpc.site_vpc.id}"
  state  = "available"

  tags {
    Name = "${var.private_subnet}"
  }
}

variable "vpc_name" {}
variable "private_subnet" {}
variable "open_port_range" {
  description = ""
  type = list
}

variable "tag" {
  description = ""
}
variable "iam_instance_profile_name" {}
variable "key_name" {}
variable "app_instance_type" {}
variable "home_volume_size" {}

output "security_group_id" {
  value = "${aws_security_group.application.id}"
}
