data "terraform_remote_state" "s3" {
  backend = "s3"

  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/s3/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  s3_arn = "${data.terraform_remote_state.s3.harbor_registry_arn}"
}

data "aws_iam_policy_document" "harbor_registry" {
  statement {
    effect    = "Allow"
    resources = ["${local.s3_arn}"]

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["${local.s3_arn}/*"]

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListMultipartUploadParts",
      "s3:AbortMultipartUpload",
    ]
  }
}

data "aws_iam_policy_document" "harbor_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
