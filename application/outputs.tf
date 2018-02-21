output "security_group_id" {
  value = "${aws_security_group.application.id}"
}
output "static_ip" {
  value = "${aws_network_interface.application.private_ip}"
}