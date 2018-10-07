data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "cidr" {
  backend = "s3"
  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/routing/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "keys" {
  backend = "s3"
  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/ssh-keys/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"
  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/dns/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg_openvpn" {
  backend = "s3"
  config {
    bucket = "showseeker-terraform"
    key    = "aws/us-east-1/security-groups/openvpn/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
