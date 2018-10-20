locals {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_route53_zone" "private" {
  name    = "showseeker.com"
  comment = "ShowSeeker Internal DNS"
  vpc_id  = "${local.vpc_id}"
}

resource "aws_route53_record" "pilot_db_dev" {
  zone_id = "${var.public_zone_id}"
  name    = "db.pilot.dev.shseekr.com"
  type    = "A"
  ttl     = "300"
  records = ["23.253.213.206"]
}
