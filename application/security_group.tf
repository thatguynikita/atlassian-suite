# GEt rid of inline blocks
resource "aws_security_group" "application" {
  name        = "${var.name_tag}_sg"
  description = "Allow SSH and application access from VPC"
  vpc_id = "${data.aws_vpc.site_vpc.id}"

  tags {
    Name = "${var.name_tag}"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "application" {
  type              = "ingress"
  security_group_id = "${aws_security_group.application.id}"
  from_port         = "${var.open_port_range[0]}"
  protocol          = "tcp"
  to_port           = "${var.open_port_range[1]}"
  cidr_blocks       = ["${data.aws_vpc.site_vpc.cidr_block}"]
  description       = "Allow application Tomcat ports"
}
