data "aws_vpc" "site_vpc" {
  state = "available"

  tags {
    Name = "${var.vpc_name}"
  }
}

### WE WANT MORE more subnets available!!! Use both of the available! Then interate through the list and setup data resources

data "aws_subnet" "private" {
  vpc_id = "${data.aws_vpc.site_vpc.id}"
  state  = "available"

  tags {
    Name = "${var.private_subnet_name}"
  }
}

resource "aws_security_group" "bitbucket" {
  name        = "atlassian_bitbucket"
  description = "Only listening ports for SSH and Tomcat allowed"
  vpc_id      = "${data.aws_vpc.site_vpc.id}"

  tags {
    Name = "atlassian_bitbucket"
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
    to_port     = 7990
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jira" {
  name        = "atlassian_jira"
  description = "Only listening ports for SSH and Tomcat allowed"
  vpc_id      = "${data.aws_vpc.site_vpc.id}"

  tags {
    Name = "atlassian_jira"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "confluence" {
  name        = "atlassian_confluence"
  description = "Only listening ports for SSH and Tomcat allowed"
  vpc_id      = "${data.aws_vpc.site_vpc.id}"

  tags {
    Name = "atlassian_confluence"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  ingress {
    from_port   = 8090
    protocol    = "tcp"
    to_port     = 8091
    cidr_blocks = ["${data.aws_vpc.site_vpc.cidr_block}"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "postgresdb" {
  name        = "atlassian_postgres"
  description = "SG for accessing PostgreSQL DB from instances that use it"
  vpc_id      = "${data.aws_vpc.site_vpc.id}"

  tags {
    Name = "atlassian_postgres"
  }

  ingress {
    from_port = 5432
    protocol  = "tcp"
    to_port   = 5432

    security_groups = ["${aws_security_group.bitbucket.id}",
      "${aws_security_group.confluence.id}",
      "${aws_security_group.jira.id}",
    ]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Might not need these interfaces at all!!! Need to check how it works wiyout them
resource "aws_network_interface" "bitbucket" {
  subnet_id       = "${data.aws_subnet.private.id}"
  security_groups = ["${aws_security_group.bitbucket.id}"]
  description     = "Re-attachable ENI for bitbucket instance"
}

resource "aws_network_interface" "jira" {
  subnet_id       = "${data.aws_subnet.private.id}"
  security_groups = ["${aws_security_group.jira.id}"]
  description     = "Re-attachable ENI for jira instance"
}

resource "aws_network_interface" "confluence" {
  subnet_id       = "${data.aws_subnet.private.id}"
  security_groups = ["${aws_security_group.confluence.id}"]
  description     = "Re-attachable ENI for confluence instance"
}
