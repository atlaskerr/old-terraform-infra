data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}
