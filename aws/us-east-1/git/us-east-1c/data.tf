data "terraform_remote_state" "main" {
  backend = "s3"

  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"

  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/security-groups/terraform.tfstate"
    region = "us-east-1"
  }
}
