resource "aws_security_group" "openvpn" {
  name        = "openvpn"
  description = "OpenVPN Security Group"
  vpc_id      = "${data.terraform_remote_state.main.vpc_id}"
}

resource "aws_security_group_rule" "openvpn_ssh_in_all" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "openvpn_ssh_out_vpc" {
  type              = "egress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${data.terraform_remote_state.main.vpc_cidr}"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "openvpn_in_all" {
  type              = "ingress"
  from_port         = "1194"
  to_port           = "1194"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "openvpn_http_out_all" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "openvpn_https_out_all" {
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

output "openvpn" {
  value = "${aws_security_group.openvpn.id}"
}
