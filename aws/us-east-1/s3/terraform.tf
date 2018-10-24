terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/s3/terraform.tfstate"
    region = "us-east-1"
  }
}
