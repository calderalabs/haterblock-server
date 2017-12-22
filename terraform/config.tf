terraform {
  backend "s3" {
    bucket = "calderalabs-terraform-test"
    region = "eu-west-1"
  }
}
