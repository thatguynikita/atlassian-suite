### Might not need these interfaces at all!!! Need to check how it works wiyout them
resource "aws_network_interface" "application" {
  subnet_id       = "${data.aws_subnet.private.id}"
  security_groups = ["${aws_security_group.application.id}"]
  description     = "Re-attachable ENI for ${var.tag} instance"
}