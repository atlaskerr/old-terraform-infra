locals {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${local.vpc_id}"

  tags {
    Name = "Public route table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${local.vpc_id}"

  tags {
    Name = "Private route table"
  }
}
