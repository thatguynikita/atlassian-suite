variable "name_tag" {
  description = "Used for tagging all instance-related resources"
}
variable "vpc_id" {}
variable "private_subnet" {}
variable "iam_instance_profile_name" {}
variable "key_name" {}
variable "instance_type" {}
variable "home_volume_size" {
  description = "Size for re-attachable home volume"
}
variable "db_endpoint" {}
variable "db_credentials" {
  type = "list"
}
variable "ansible_playbook" {}
variable "proxied_url" {
  description = "Domain name that reverse proxy will be configured to serve. Context path should be specified here if needed"
}
variable "listening_port" {
  description = "Open port for application. Applied to security group and passed as variable to playbook"
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
