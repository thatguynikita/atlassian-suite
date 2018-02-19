variable "name_tag" {
  description = "Used for tagging all instance-related resources"
}
variable "vpc_id" {}
variable "private_subnets" {
  type = "list"
}
variable "listening_port" {
  description = "DB listening port"
}
variable "allowed_sgs" {
  description = "Used to allow other security groups to connect"
  type = "list"
}
variable "instance_class" {}
variable "engine" {}
variable "allocated_storage" {}
variable "username" {}
variable "password" {}

output "endpoint" {
  value = "${aws_db_instance.db.endpoint}"
}
