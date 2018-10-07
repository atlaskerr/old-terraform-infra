resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "showseeker-vpc"
    Cost_Center = "INFRA"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
}