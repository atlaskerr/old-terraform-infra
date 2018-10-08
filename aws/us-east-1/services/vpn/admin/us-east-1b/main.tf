locals {
  route_table_id  = "${data.terraform_remote_state.cidr.public_table_id}"
  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  vpn_cidr        = "${data.terraform_remote_state.cidr.admin_vpn_us_east_1b}"
  key_name        = "${data.terraform_remote_state.keys.atlas_key_name}"
  sg_openvpn_id   = "${data.terraform_remote_state.sg_openvpn.sg_id}"
  shseekr_zone_id = "${data.terraform_remote_state.dns.shseekr_public_zone_id}"
}

resource "aws_route_table_association" "vpn_us_east_1b" {
  subnet_id      = "${aws_subnet.vpn_us_east_1b.id}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_subnet" "vpn_us_east_1b" {
  vpc_id                  = "${local.vpc_id}"
  availability_zone       = "us-east-1b"
  cidr_block              = "${local.vpn_cidr}"
  map_public_ip_on_launch = true

  tags {
    Name        = "vpn-subnet-us-east-1b"
    Cost_Center = "INFRA"
  }
}

resource "aws_instance" "vpn1" {
  ami                    = "${data.aws_ami.centos.id}"
  key_name               = "${local.key_name}"
  instance_type          = "t3.micro"
  subnet_id              = "${aws_subnet.vpn_us_east_1b.id}"
  vpc_security_group_ids = ["${local.sg_openvpn_id}"]

  tags {
    Name = "Admin VPN"
  }
}

resource "aws_route53_record" "vpn1" {
  zone_id = "${local.shseekr_zone_id}"
  name    = "vpn1.admin.shseekr.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.vpn1.public_ip}"]
}
