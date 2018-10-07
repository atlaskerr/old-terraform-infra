output "igw_id" {
  value = "${aws_internet_gateway.igw.id}"
}

output "nat_ip" {
  value = "${aws_eip.nat.id}"
}
