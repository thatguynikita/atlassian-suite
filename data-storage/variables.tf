data "aws_vpc" "site_vpc" {
  state = "available"

  tags {
    Name = "${var.vpc_name}"
  }
}

variable "vpc_name" {}
variable "private_subnets" {}

variable "instance_class" {}
variable "engine" {}
variable "allocated_storage" {}
variable "tag" {
  description = ""
}
variable "username" {}
variable "password" {}

variable "allowed_sgs" {
  description = "SGs to allow traffic from"
  type = list
}
variable "open_port_range" {
  description = ""
  type = list
}