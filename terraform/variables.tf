variable "ssh_public_key_file" {}
variable "app_name" {}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "aws_database_type" {
  default = "db.t2.micro"
}

variable "database_username" {
  default = "postgres"
}
