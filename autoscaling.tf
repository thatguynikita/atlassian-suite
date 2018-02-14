resource "aws_autoscaling_group" "bitbucket" {
  launch_configuration = "${aws_launch_configuration.bitbucket.name}"
  max_size             = 1
  min_size             = 1
  name                 = "atlassian_bitbucket_asg"
  vpc_zone_identifier  = ["${data.aws_subnet.private.id}"]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Bitbucket server"
  }
}

resource "aws_autoscaling_group" "jira" {
  launch_configuration = "${aws_launch_configuration.jira.name}"
  max_size             = 1
  min_size             = 1
  name                 = "atlassian_jira_asg"
  vpc_zone_identifier  = ["${data.aws_subnet.private.id}"]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Jira server"
  }
}

resource "aws_autoscaling_group" "confluence" {
  launch_configuration = "${aws_launch_configuration.confluence.name}"
  max_size             = 1
  min_size             = 1
  name                 = "atlassian_confluence_asg"
  vpc_zone_identifier  = ["${data.aws_subnet.private.id}"]

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Confluence server"
  }
}
