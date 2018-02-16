variable "name_tag" {
  description = "Used for tagging all instance-related resources"
}
variable "vpc_id" {}
variable "private_subnet" {}
variable "open_port_range" {
  description = "Open port range for security group"
  type = "list"
}
variable "iam_instance_profile_name" {}
variable "key_name" {}
variable "instance_type" {}
variable "home_volume_size" {
  description = "Size for re-attachable home volume"
}
variable "db_endpoint" {
  description = "DB endpoint for applications"
}

data "aws_vpc" "site_vpc" {
  id = "${var.vpc_id}"
  state = "available"
}
data "aws_subnet" "private" {
  id = "${var.private_subnet}"
  vpc_id = "${data.aws_vpc.site_vpc.id}"
  state  = "available"
}

output "security_group_id" {
  value = "${aws_security_group.application.id}"
}