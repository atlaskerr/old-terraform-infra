locals {
  harbor_policy        = "${data.aws_iam_policy_document.harbor_registry.json}"
  harbor_assume_policy = "${data.aws_iam_policy_document.harbor_assume_role.json}"
}

resource "aws_iam_policy" "harbor_registry" {
  name        = "harbor-registry"
  description = "Harbor Registry S3 Access"
  policy      = "${local.harbor_policy}"
}

resource "aws_iam_role" "harbor_registry" {
  name               = "harbor-s3-access"
  assume_role_policy = "${local.harbor_assume_policy}"
}

resource "aws_iam_policy_attachment" "harbor_registry" {
  name       = "harbor-attachment"
  roles      = ["${aws_iam_role.harbor_registry.name}"]
  policy_arn = "${aws_iam_policy.harbor_registry.arn}"
}

resource "aws_iam_instance_profile" "harbor_registry" {
  name = "harbor-profile"
  role = "${aws_iam_role.harbor_registry.name}"
}
