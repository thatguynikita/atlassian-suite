data "aws_subnet" "multi_az_1" {
  vpc_id = "${data.aws_vpc.site_vpc.id}"
  state  = "available"

  tags {
    Name = "${var.private_subnets[0]}"
  }
}

data "aws_subnet" "multi_az_2" {
  vpc_id = "${data.aws_vpc.site_vpc.id}"
  state  = "available"

  tags {
    Name = "${var.private_subnets[1]}"
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.tag}"
  subnet_ids = ["${data.aws_subnet.multi_az_1.id}","${data.aws_subnet.multi_az_2.id}"]

  tags {
    Name = "DB subnet group for ${var.tag}"
  }
}