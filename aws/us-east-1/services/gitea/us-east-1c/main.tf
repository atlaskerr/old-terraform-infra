locals {
  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  route_table_id  = "${data.terraform_remote_state.cidr.private_table_id}"
  git_cidr        = "${data.terraform_remote_state.cidr.git_us_east_1c}"
  key_name        = "${data.terraform_remote_state.keys.atlas_key_name}"
  sg_id           = "${data.terraform_remote_state.sg_gitea.sg_id}"
  shseekr_zone_id = "${data.terraform_remote_state.dns.shseekr_private_zone_id}"

  vol_id = "${data.terraform_remote_state.storage.gitea_repo_storage_vol_id}"
}

resource "aws_route_table_association" "git_us_east_1c" {
  subnet_id      = "${aws_subnet.git_us_east_1c.id}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_subnet" "git_us_east_1c" {
  vpc_id                  = "${local.vpc_id}"
  availability_zone       = "us-east-1c"
  cidr_block              = "${local.git_cidr}"
  map_public_ip_on_launch = false

  tags {
    Name        = "git-subnet-us-east-1c"
    Cost_Center = "INFRA"
  }
}

resource "aws_instance" "git" {
  ami                    = "${data.aws_ami.centos.id}"
  key_name               = "${local.key_name}"
  instance_type          = "t3.micro"
  subnet_id              = "${aws_subnet.git_us_east_1c.id}"
  vpc_security_group_ids = ["${local.sg_id}"]

  tags {
    Name = "Gitea"
  }
}

resource "aws_volume_attachment" "repository_storage" {
  device_name = "/dev/sdb"
  instance_id = "${aws_instance.git.id}"
  volume_id   = "${local.vol_id}"
}

resource "aws_route53_record" "git" {
  zone_id = "${local.shseekr_zone_id}"
  name    = "git.showseeker.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.git.private_ip}"]
}
