locals {
  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  route_table_id  = "${data.terraform_remote_state.cidr.private_table_id}"
  clair_cidr      = "${data.terraform_remote_state.cidr.clair_us_east_1c}"
  key_name        = "${data.terraform_remote_state.keys.atlas_key_name}"
  sg_id           = "${data.terraform_remote_state.sg_clair.sg_id}"
  shseekr_zone_id = "${data.terraform_remote_state.dns.shseekr_private_zone_id}"
}

resource "aws_subnet" "clair_us_east_1c" {
  vpc_id                  = "${local.vpc_id}"
  availability_zone       = "us-east-1c"
  cidr_block              = "${local.clair_cidr}"
  map_public_ip_on_launch = false

  tags {
    Name        = "clair-subnet-us-east-1c"
    Cost_Center = "INFRA"
  }
}

resource "aws_route_table_association" "clair_us_east_1c" {
  subnet_id      = "${aws_subnet.clair_us_east_1c.id}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_instance" "clair" {
  ami                    = "${data.aws_ami.centos.id}"
  key_name               = "${local.key_name}"
  instance_type          = "t3.micro"
  subnet_id              = "${aws_subnet.clair_us_east_1c.id}"
  vpc_security_group_ids = ["${local.sg_id}"]

  tags {
    Name = "Clair Container Vulnerability Analysis Server"
  }
}

resource "aws_route53_record" "clair" {
  zone_id = "${local.shseekr_zone_id}"
  name    = "clair.showseeker.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.clair.private_ip}"]
}
