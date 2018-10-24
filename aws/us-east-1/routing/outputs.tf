output "public_table_id" {
  value = "${aws_route_table.public.id}"
}

output "private_table_id" {
  value = "${aws_route_table.private.id}"
}

# Public Subnets
output "igw" {
  value = "192.168.1.0/24"
}

output "admin_vpn_us_east_1b" {
  value = "192.168.2.0/24"
}

# Private Subnets
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

output "postgres_clair_us_east_1c" {
  value = "192.168.7.0/24"
}

output "clair_us_east_1c" {
  value = "192.168.8.0/24"
}

output "ldap_us_east_1b" {
  value = "192.168.9.0/24"
}

output "postgres_notary_us_east_1c" {
  value = "192.168.10.0/24"
}

output "notarysigner_us_east_1c" {
  value = "192.168.11.0/24"
}

output "notary_us_east_1c" {
  value = "192.168.12.0/24"
}

output "postgres_harbor_us_east_1c" {
  value = "192.168.13.0/24"
}

output "harbor_us_east_1c" {
  value = "192.168.14.0/24"
}
