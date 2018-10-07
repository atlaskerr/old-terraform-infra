terraform {
  backend "s3" {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/ssh-keys/terraform.tfstate"
    region = "us-east-1"
  }
}
