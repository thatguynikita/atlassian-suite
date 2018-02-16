resource "aws_ebs_volume" "application" {
  availability_zone = "${data.aws_subnet.private.availability_zone}"
  size              = "${var.home_volume_size}"
  type              = "gp2"

  tags {
    Name = "${var.name_tag}_home"
  }
}
