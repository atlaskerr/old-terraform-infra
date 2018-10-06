resource "aws_route_table_association" "git_us_east_1c" {
  subnet_id      = "${aws_subnet.git_us_east_1c.id}"
  route_table_id = "${data.terraform_remote_state.main.route_table_id}"
}
