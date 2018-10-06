resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

output "route_table_id" {
  value = "${aws_route_table.main.id}"
}
