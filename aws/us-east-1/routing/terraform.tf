terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/routing/terraform.tfstate"
    region = "us-east-1"
  }
}
