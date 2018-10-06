data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "vpn_1" {
  ami           = "${data.aws_ami.centos.id}"
  key_name      = "${data.terraform_remote_state.main.atlas_key_name}"
  instance_type = "t3.micro"
  subnet_id     = "${aws_subnet.vpn_us_east_1b.id}"

  vpc_security_group_ids = [
    "${data.terraform_remote_state.security_groups.openvpn}",
  ]
}

resource "aws_route53_record" "vpn_admin_us_east_1b" {
  zone_id = "${data.terraform_remote_state.main.shseekr_zone_id}"
  name    = "vpn1.admin.shseekr.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.vpn_1.public_ip}"]
}
