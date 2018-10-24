output "harbor_registry_arn" {
  value = "${aws_s3_bucket.harbor_registry.arn}"
}
