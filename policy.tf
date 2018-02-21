resource "aws_iam_role_policy" "ec2_access" {
  name   = "atlassian-ec2-readonly"
  role   = "${aws_iam_role.ec2_assume_role.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_role" "ec2_assume_role" {
  name        = "atlassian-ec2-access"
  description = "Full access to EC2 instances"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "atlassian-ec2-access"
  role = "${aws_iam_role.ec2_assume_role.name}"
}