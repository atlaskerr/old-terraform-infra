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
  description       = "Allow all inbound SSH traffic on port 22."
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "openvpn_in_all" {
  description       = "Allow all inbound OpenVPN UDP traffic on port 1194."
  type              = "ingress"
  from_port         = "1194"
  to_port           = "1194"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "allow_all_out" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}
