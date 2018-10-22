terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/services/notary/notarysigner/us-east-1c/terraform.tfstate"
    region = "us-east-1"
  }
}
