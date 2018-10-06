resource "aws_subnet" "git_us_east_1c" {
  vpc_id                  = "${data.terraform_remote_state.main.vpc_id}"
  availability_zone       = "us-east-1c"
  cidr_block = "${data.terraform_remote_state.main.git_subnet_us_east_1c}"

  tags {
    Name        = "git-subnet-us-east-1c"
    Cost_Center = "INFRA"
  }
}
