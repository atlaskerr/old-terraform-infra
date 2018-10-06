resource "aws_subnet" "igw" {
  availability_zone = "us-east-1b"
  cidr_block        = "192.168.1.0/24"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Cost_Center = "INFRA"
  }
}

resource "aws_route" "igw" {
  route_table_id         = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "igw" {
  subnet_id      = "${aws_subnet.igw.id}"
  route_table_id = "${aws_route_table.main.id}"
}

output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}
