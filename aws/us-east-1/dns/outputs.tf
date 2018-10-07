output "shseekr_public_zone_id" {
  value = "Z1KO627SVN91CJ"
}

output "shseekr_private_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}
