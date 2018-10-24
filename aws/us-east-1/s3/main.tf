resource "aws_s3_bucket" "harbor_registry" {
  bucket = "showseeker-harbor-registry"
  acl    = "private"

  tags {
    Name = "Harbor Registry Images"
  }
}
