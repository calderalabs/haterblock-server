terraform {
  backend "s3" {
    bucket = "eugeniodepalo-terraform"
    region = "eu-west-1"
    key = "haterblock"
  }
}
