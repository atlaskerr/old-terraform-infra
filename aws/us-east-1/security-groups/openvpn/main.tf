locals {
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"
  vpc_cidr = "${data.terraform_remote_state.vpc.vpc_cidr}"

}

resource "aws_security_group" "openvpn" {
  name        = "openvpn"
  description = "OpenVPN Security Group"
  vpc_id      = "${local.vpc_id}"
  tags {
    Name = "OpenVPN"
  }
}

resource "aws_security_group_rule" "ssh_in_all" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "ssh_out_vpc" {
  type              = "egress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${local.vpc_cidr}"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "in_all" {
  type              = "ingress"
  from_port         = "1194"
  to_port           = "1194"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "http_out_all" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "https_out_all" {
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}
