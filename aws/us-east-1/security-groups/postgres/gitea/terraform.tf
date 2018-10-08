terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/security-groups/postgres/gitea/terraform.tfstate"
    region = "us-east-1"
  }
}
