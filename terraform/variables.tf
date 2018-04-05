variable "ssh_public_key_file" {}
variable "aws_access_key_id" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "dnsimple_account" {}
variable "dnsimple_token" {}

variable "app_name" {
  default = "haterblock"
}

variable "domain" {
  default = "gethaterblock.com"
}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "aws_database_type" {
  default = "db.t2.micro"
}
