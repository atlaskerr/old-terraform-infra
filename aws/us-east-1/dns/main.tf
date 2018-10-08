locals {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_route53_zone" "private" {
  name    = "shseekr.com"
  comment = "ShowSeeker Internal DNS"
  vpc_id  = "${local.vpc_id}"
}
