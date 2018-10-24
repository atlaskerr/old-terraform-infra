output "harbor_iam_profile" {
  value = "${aws_iam_instance_profile.harbor_registry.name}"
}
