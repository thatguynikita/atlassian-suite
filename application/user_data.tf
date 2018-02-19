data "archive_file" "playbook" {
  source_dir  = "${dirname(var.ansible_playbook)}"
  type        = "zip"
  output_path = "files/${element(split(".", basename(var.ansible_playbook)), 0)}.zip"
}

data "template_file" "cloud-config" {
  template = "${file("${path.module}/cloud-config.tpl")}"

  vars {
    playbook_name  = "${element(split(".", basename(var.ansible_playbook)), 0)}"
    encoded        = "${base64encode(file(data.archive_file.playbook.output_path))}"
    db_endpoint    = "${var.db_endpoint}"
    db_username    = "${var.db_credentials[0]}"
    db_password    = "${var.db_credentials[1]}"
    website_url    = "${var.website_url}"
    listening_port = "${var.listening_port}"
    ebs_id         = "${aws_ebs_volume.application.id}"
    eni_id         = "${aws_network_interface.application.id}"
  }
}

data "template_cloudinit_config" "userdata" {
  gzip          = true
  base64_encode = true

  "part" {
    content      = "${data.template_file.cloud-config.rendered}"
    content_type = "text/cloud-config"
  }
}