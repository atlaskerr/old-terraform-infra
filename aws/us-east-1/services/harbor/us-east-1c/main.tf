locals {
  vpc_id         = "${data.terraform_remote_state.vpc.vpc_id}"
  route_table_id = "${data.terraform_remote_state.cidr.private_table_id}"
  harbor_cidr    = "${data.terraform_remote_state.cidr.harbor_us_east_1c}"
  key_name       = "${data.terraform_remote_state.keys.atlas_key_name}"
  sg_id          = "${data.terraform_remote_state.sg_harbor.sg_id}"
  zone_id        = "${data.terraform_remote_state.dns.private_zone_id}"
  harbor_profile = "${data.terraform_remote_state.iam.harbor_iam_profile}"
}

resource "aws_subnet" "harbor_us_east_1c" {
  vpc_id                  = "${local.vpc_id}"
  availability_zone       = "us-east-1c"
  cidr_block              = "${local.harbor_cidr}"
  map_public_ip_on_launch = false

  tags {
    Name        = "harbor-subnet-us-east-1c"
    Cost_Center = "INFRA"
  }
}

resource "aws_route_table_association" "harbor_us_east_1c" {
  subnet_id      = "${aws_subnet.harbor_us_east_1c.id}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_instance" "harbor" {
  ami                    = "${data.aws_ami.centos.id}"
  key_name               = "${local.key_name}"
  instance_type          = "t3.medium"
  subnet_id              = "${aws_subnet.harbor_us_east_1c.id}"
  vpc_security_group_ids = ["${local.sg_id}"]
  iam_instance_profile   = "${local.harbor_profile}"

  tags {
    Name = "Harbor"
  }
}

resource "aws_route53_record" "harbor" {
  zone_id = "${local.zone_id}"
  name    = "img.showseeker.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.harbor.private_ip}"]
}
