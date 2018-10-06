resource "aws_security_group" "postgres" {
  name        = "postgres"
  description = "Postgres Security Group"
  vpc_id      = "${data.terraform_remote_state.main.vpc_id}"
}

resource "aws_security_group_rule" "postgres_postgres_in_vpc" {
  type              = "ingress"
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks       = ["${data.terraform_remote_state.main.vpc_cidr}"]
  security_group_id = "${aws_security_group.gitea.id}"
}

resource "aws_security_group_rule" "postgres_ssh_in_vpc" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${data.terraform_remote_state.main.vpc_cidr}"]
  security_group_id = "${aws_security_group.openvpn.id}"
}

resource "aws_security_group_rule" "postgres_http_out_all" {
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.gitea.id}"
}

resource "aws_security_group_rule" "postgres_https_out_all" {
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.gitea.id}"
}
