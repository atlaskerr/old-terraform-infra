locals {
  route_table_id  = "${data.terraform_remote_state.cidr.private_table_id}"
  vpc_id          = "${data.terraform_remote_state.vpc.vpc_id}"
  cidr            = "${data.terraform_remote_state.cidr.postgres_clair_us_east_1c}"
  key_name        = "${data.terraform_remote_state.keys.atlas_key_name}"
  sg_id           = "${data.terraform_remote_state.security_groups.sg_id}"
  shseekr_zone_id = "${data.terraform_remote_state.dns.shseekr_private_zone_id}"
  vol_id          = "${data.terraform_remote_state.storage.postgres_clair_db_vol_id}"
}

resource "aws_subnet" "postgres_clair_us_east_1c" {
  vpc_id                  = "${local.vpc_id}"
  availability_zone       = "us-east-1c"
  cidr_block              = "${local.cidr}"
  map_public_ip_on_launch = false

  tags {
    Name        = "postgres-clair-subnet-us-east-1c"
    Cost_Center = "INFRA"
  }
}

locals {
  subnet_id = "${aws_subnet.postgres_clair_us_east_1c.id}"
}

resource "aws_route_table_association" "postgres_clair_us_east_1c" {
  subnet_id      = "${local.subnet_id}"
  route_table_id = "${local.route_table_id}"
}

resource "aws_instance" "postgres_clair_db" {
  ami                    = "${data.aws_ami.centos.id}"
  key_name               = "${local.key_name}"
  instance_type          = "t3.micro"
  subnet_id              = "${local.subnet_id}"
  vpc_security_group_ids = ["${local.sg_id}"]

  tags {
    Name = "Clair Postgres DB"
  }
}

locals {
  instance_id = "${aws_instance.postgres_clair_db.id}"
}

resource "aws_volume_attachment" "pg_data_vol" {
  device_name = "sdd"
  instance_id = "${local.instance_id}"
  volume_id   = "${local.vol_id}"
}

resource "aws_route53_record" "db_dot_clair" {
  zone_id = "${local.shseekr_zone_id}"
  name    = "db.clair.showseeker.com"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.postgres_clair_db.private_ip}"]
}
