terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/services/postgres/clair/us-east-1c/terraform.tfstate"
    region = "us-east-1"
  }
}
