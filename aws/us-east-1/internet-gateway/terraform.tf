terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/internet-gateway/terraform.tfstate"
    region = "us-east-1"
  }
}
