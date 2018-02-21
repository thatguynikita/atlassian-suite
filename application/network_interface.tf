resource "aws_network_interface" "application" {
  subnet_id       = "${data.aws_subnet.private.id}"
  security_groups = ["${aws_security_group.application.id}"]
  description     = "Re-attachable ENI for ${var.name_tag} instance"

  tags {
    Name = "${var.name_tag}_eni"
  }
}