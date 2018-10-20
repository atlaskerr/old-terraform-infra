locals {
  route_table_id  = "${data.terraform_remote_state.cidr.public_table_id}"
  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  ldap_cidr       = "${data.terraform_remote_state.cidr.ldap_us_east_1b}"
  key_name        = "${data.terraform_remote_state.keys.atlas_key_name}"
  sg_id           = "${data.terraform_remote_state.sg_ldap.sg_id}"
  public_zone_id  = "${data.terraform_remote_state.dns.public_zone_id}"
  private_zone_id = "${data.terraform_remote_state.dns.private_zone_id}"
}

resource "aws_route_table_association" "ldap_us_east_1b" {
  subnet_id      = "${aws_subnet.ldap_us_east_1b.id}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_subnet" "ldap_us_east_1b" {
  vpc_id                  = "${local.vpc_id}"
  availability_zone       = "us-east-1b"
  cidr_block              = "${local.ldap_cidr}"
  map_public_ip_on_launch = true

  tags {
    Name        = "ldap-subnet-us-east-1b"
    Cost_Center = "INFRA"
  }
}

resource "aws_instance" "ldap" {
  ami                    = "${data.aws_ami.centos.id}"
  key_name               = "${local.key_name}"
  instance_type          = "t3.micro"
  subnet_id              = "${aws_subnet.ldap_us_east_1b.id}"
  vpc_security_group_ids = ["${local.sg_id}"]

  tags {
    Name = "LDAP Server"
  }
}

# DNS for public zone
resource "aws_route53_record" "ldap_shseekr" {
  zone_id = "${local.public_zone_id}"
  name    = "ldap.shseekr.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ldap.public_ip}"]
}

# DNS for private zone
resource "aws_route53_record" "ldap_showseeker" {
  zone_id = "${local.private_zone_id}"
  name    = "ldap.showseeker.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ldap.private_ip}"]
}
