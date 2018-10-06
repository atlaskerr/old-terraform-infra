resource "aws_security_group" "gitea" {
  name        = "gitea"
  description = "Gitea Security Group"
  vpc_id      = "${data.terraform_remote_state.main.vpc_id}"
}

resource "aws_security_group_rule" "gitea_ssh_in_vpc" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${data.terraform_remote_state.main.vpc_cidr}"]
  security_group_id = "${aws_security_group.gitea.id}"
}

resource "aws_security_group_rule" "gitea_https_in_vpc" {
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["${data.terraform_remote_state.main.vpc_cidr}"]
  security_group_id = "${aws_security_group.gitea.id}"
}

resource "aws_security_group_rule" "gitea_http_out_all" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.gitea.id}"
}

resource "aws_security_group_rule" "gitea_https_out_all" {
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.gitea.id}"
}
