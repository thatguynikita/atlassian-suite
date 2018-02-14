provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.profile}"
}

terraform {
  backend "s3" {
    bucket = "${var.backend_bucket}"
    key    = "${var.backend_path}"
    region = "${var.backend_region}"
  }
}
