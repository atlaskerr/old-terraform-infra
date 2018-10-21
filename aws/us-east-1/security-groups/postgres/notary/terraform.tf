terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/security-groups/postgres/notary/terraform.tfstate"
    region = "us-east-1"
  }
}
