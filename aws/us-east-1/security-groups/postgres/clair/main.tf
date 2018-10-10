locals {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_security_group" "postgres_clair" {
  name        = "postgres_clair"
  description = "Postgres for Clair Security Group"
  vpc_id      = "${local.vpc_id}"
}

locals {
  sg_id         = "${aws_security_group.postgres_clair.id}"
  vpn_cidr      = "${data.terraform_remote_state.cidr.admin_vpn_us_east_1b}"
  clair_cidr = "${data.terraform_remote_state.cidr.clair_us_east_1c}"
}

resource "aws_security_group_rule" "pg_vpn_in" {
  description       = "Allow Postgres port 5432 traffic from VPN subnet"
  type              = "ingress"
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks       = ["${local.vpn_cidr}"]
  security_group_id = "${local.sg_id}"
}

resource "aws_security_group_rule" "pg_vpn_out" {
  description       = "Allow Postgres port 5432 traffic out to VPN subnet"
  type              = "egress"
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks       = ["${local.vpn_cidr}"]
  security_group_id = "${local.sg_id}"
}

resource "aws_security_group_rule" "pg_clair_in" {
  description       = "Allow Postgres port 5432 traffic from Clair subnet"
  type              = "ingress"
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks       = ["${local.clair_cidr}"]
  security_group_id = "${local.sg_id}"
}

resource "aws_security_group_rule" "pg_clair_out" {
  description       = "Allow Postgres port 5432 traffic to Clair subnet"
  type              = "egress"
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks       = ["${local.clair_cidr}"]
  security_group_id = "${local.sg_id}"
}

resource "aws_security_group_rule" "ssh_in_vpn" {
  description       = "Allow SSH port 22 traffic from VPN subnet"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = ["${local.vpn_cidr}"]
  security_group_id = "${local.sg_id}"
}

resource "aws_security_group_rule" "http_out_all" {
  description       = "Allow HTTP port 80 traffic to everywhere"
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${local.sg_id}"
}

resource "aws_security_group_rule" "https_out_all" {
  description       = "Allow HTTPS port 443 traffic to everywhere"
  type              = "egress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${local.sg_id}"
}
