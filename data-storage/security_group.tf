# Get rid of inline blocks
resource "aws_security_group" "db" {
  name        = "${var.tag}"
  description = "SG for accessing ${var.tag} DB from instances that use it"

  tags {
    Name = "${var.tag}"
  }

  ingress {
    from_port       = "${var.open_port_range[0]}"
    protocol        = "tcp"
    to_port         = "${var.open_port_range[1]}"
    security_groups = "${var.allowed_sgs}"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
