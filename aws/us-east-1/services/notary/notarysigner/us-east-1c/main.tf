locals {
  vpc_id            = "${data.terraform_remote_state.vpc.vpc_id}"
  route_table_id    = "${data.terraform_remote_state.cidr.private_table_id}"
  notarysigner_cidr = "${data.terraform_remote_state.cidr.notarysigner_us_east_1c}"
  key_name          = "${data.terraform_remote_state.keys.atlas_key_name}"
  sg_id             = "${data.terraform_remote_state.sg_notarysigner.sg_id}"
  zone_id           = "${data.terraform_remote_state.dns.private_zone_id}"
}

resource "aws_subnet" "notarysigner_us_east_1c" {
  vpc_id                  = "${local.vpc_id}"
  availability_zone       = "us-east-1c"
  cidr_block              = "${local.notarysigner_cidr}"
  map_public_ip_on_launch = false

  tags {
    Name        = "notarysigner-subnet-us-east-1c"
    Cost_Center = "INFRA"
  }
}

resource "aws_route_table_association" "notarysigner_us_east_1c" {
  subnet_id      = "${aws_subnet.notarysigner_us_east_1c.id}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_instance" "notarysigner" {
  ami                    = "${data.aws_ami.centos.id}"
  key_name               = "${local.key_name}"
  instance_type          = "t3.micro"
  subnet_id              = "${aws_subnet.notarysigner_us_east_1c.id}"
  vpc_security_group_ids = ["${local.sg_id}"]

  tags {
    Name = "Notary Signing Server"
  }
}

resource "aws_route53_record" "notarysigner" {
  zone_id = "${local.zone_id}"
  name    = "notarysigner.showseeker.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.notarysigner.private_ip}"]
}
