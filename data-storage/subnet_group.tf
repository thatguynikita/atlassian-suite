data "aws_subnet" "multi_az_1" {
  vpc_id = "${var.vpc_id}"
  state  = "available"
  id = "${var.private_subnets[0]}"
}

data "aws_subnet" "multi_az_2" {
  vpc_id = "${var.vpc_id}"
  state  = "available"
  id = "${var.private_subnets[1]}"
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.name_tag}_sg"
  subnet_ids = ["${data.aws_subnet.multi_az_1.id}","${data.aws_subnet.multi_az_2.id}"]

  tags {
    Name = "DB subnet group for ${var.name_tag}"
  }
}