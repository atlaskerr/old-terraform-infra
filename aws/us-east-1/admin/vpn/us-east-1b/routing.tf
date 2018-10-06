resource "aws_route_table_association" "vpn_us_east_1b" {
  subnet_id      = "${aws_subnet.vpn_us_east_1b.id}"
  route_table_id = "${data.terraform_remote_state.main.route_table_id}"
}
