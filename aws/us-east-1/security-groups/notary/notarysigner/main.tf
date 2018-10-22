locals {
  vpc_id            = "${data.terraform_remote_state.vpc.vpc_id}"
  vpc_cidr          = "${data.terraform_remote_state.vpc.vpc_cidr}"
  vpn_cidr          = "${data.terraform_remote_state.cidr.admin_vpn_us_east_1b}"
  db_cidr           = "${data.terraform_remote_state.cidr.postgres_notary_us_east_1c}"
  notaryserver_cidr = "${data.terraform_remote_state.cidr.notary_us_east_1c}"
}

resource "aws_security_group" "notarysigner" {
  name        = "notarysigner"
  description = "Notary Signer Security Group"
  vpc_id      = "${local.vpc_id}"

  tags {
    Name = "Notary Signer Security Group"
  }
}

resource "aws_security_group_rule" "ssh_in_vpc" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${local.vpc_cidr}"]
  security_group_id = "${aws_security_group.notarysigner.id}"
}

resource "aws_security_group_rule" "pg_out" {
  type              = "egress"
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks       = ["${local.db_cidr}"]
  security_group_id = "${aws_security_group.notarysigner.id}"
}

resource "aws_security_group_rule" "https_in_vpn" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["${local.vpn_cidr}"]
  security_group_id = "${aws_security_group.notarysigner.id}"
}

resource "aws_security_group_rule" "https_in_notaryserver" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["${local.notaryserver_cidr}"]
  security_group_id = "${aws_security_group.notarysigner.id}"
}

resource "aws_security_group_rule" "http_out_all" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.notarysigner.id}"
}

resource "aws_security_group_rule" "https_out_all" {
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.notarysigner.id}"
}
