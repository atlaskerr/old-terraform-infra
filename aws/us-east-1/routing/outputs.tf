output "public_table_id" {
  value = "${aws_route_table.public.id}"
}

output "private_table_id" {
  value = "${aws_route_table.private.id}"
}

output "igw" {
  value = "192.168.1.0/24"
}

output "admin_vpn_us_east_1b" {
  value = "192.168.2.0/24"
}

output "git_us_east_1c" {
  value = "192.168.3.0/24"
}

output "postgres_gitea_us_east_1c" {
  value = "192.168.4.0/24"
}

output "concourse_us_east_1c" {
  value = "192.168.5.0/24"
}

output "postgres_concourse_us_east_1c" {
  value = "192.168.6.0/24"
}
