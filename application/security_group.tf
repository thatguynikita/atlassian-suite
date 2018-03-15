resource "aws_security_group" "application" {
  name        = "${var.name_tag}_sg"
  description = "Allow SSH and application access from VPC"
  vpc_id      = "${data.aws_vpc.site_vpc.id}"

  tags {
    Name = "${var.name_tag}"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  ingress {
    from_port   = 7990
    protocol    = "tcp"
    to_port     = 8090
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
