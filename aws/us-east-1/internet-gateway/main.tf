locals {
  vpc_id             = "${data.terraform_remote_state.vpc.vpc_id}"
  vpc_route_table_id = "${data.terraform_remote_state.vpc.route_table_id}"
  igw_cidr           = "${data.terraform_remote_state.cidr.igw}"
}

resource "aws_subnet" "igw" {
  availability_zone = "us-east-1b"
  cidr_block        = "${local.igw_cidr}"
  vpc_id            = "${local.vpc_id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${local.vpc_id}"

  tags {
    Cost_Center = "INFRA"
  }
}

resource "aws_route" "igw" {
  route_table_id         = "${local.vpc_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "igw" {
  subnet_id      = "${aws_subnet.igw.id}"
  route_table_id = "${local.vpc_route_table_id}"
}
