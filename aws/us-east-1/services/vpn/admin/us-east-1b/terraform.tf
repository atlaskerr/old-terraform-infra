terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/services/vpn/admin/us-east-1b/terraform.tfstate"
    region = "us-east-1"
  }
}
