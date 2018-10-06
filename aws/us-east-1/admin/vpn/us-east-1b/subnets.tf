resource "aws_subnet" "vpn_us_east_1b" {
  vpc_id                  = "${data.terraform_remote_state.main.vpc_id}"
  availability_zone       = "us-east-1b"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags {
    Name        = "vpn-subnet-us-east-1b"
    Cost_Center = "INFRA"
  }
}
