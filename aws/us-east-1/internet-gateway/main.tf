locals {
  vpc_id        = "${data.terraform_remote_state.vpc.vpc_id}"
  igw_cidr      = "${data.terraform_remote_state.cidr.igw}"
  public_table  = "${data.terraform_remote_state.cidr.public_table_id}"
  private_table = "${data.terraform_remote_state.cidr.private_table_id}"
}

# Internet gateway for instances with public IPs
resource "aws_internet_gateway" "igw" {
  vpc_id = "${local.vpc_id}"

  tags {
    Cost_Center = "INFRA"
  }
}

resource "aws_route" "igw" {
  route_table_id         = "${local.public_table}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_subnet" "igw" {
  availability_zone = "us-east-1b"
  cidr_block        = "${local.igw_cidr}"
  vpc_id            = "${local.vpc_id}"
}

resource "aws_route_table_association" "igw" {
  subnet_id      = "${aws_subnet.igw.id}"
  route_table_id = "${local.public_table}"
}

# Nat gateway for private subnets

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.igw.id}"
}

resource "aws_route" "nat" {
  route_table_id         = "${local.private_table}"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
  destination_cidr_block = "0.0.0.0/0"
}
