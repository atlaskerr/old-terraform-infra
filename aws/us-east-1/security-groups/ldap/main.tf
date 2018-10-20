locals {
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"
  vpc_cidr = "${data.terraform_remote_state.vpc.vpc_cidr}"
  vpn_cidr = "${data.terraform_remote_state.cidr.admin_vpn_us_east_1b}"
}

resource "aws_security_group" "ldap" {
  name        = "ldap"
  description = "LDAP Security Group"
  vpc_id      = "${local.vpc_id}"
  tags {
    Name = "389 Directory Server"
  }
}

resource "aws_security_group_rule" "in_ssh_vpn"{
  description       = "Allow all SSH from VPN"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${local.vpn_cidr}"]
  security_group_id = "${aws_security_group.ldap.id}"
}

resource "aws_security_group_rule" "ldap_in_all" {
  description       = "Allow all inbound LDAPS traffic."
  type              = "ingress"
  from_port         = "636"
  to_port           = "636"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ldap.id}"
}

resource "aws_security_group_rule" "http_out_all" {
  description       = "Allow all outbound HTTP traffic to everywhere."
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ldap.id}"
}

resource "aws_security_group_rule" "https_out_all" {
  description       = "Allow all outbound HTTPS traffic to everywhere."
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ldap.id}"
}
