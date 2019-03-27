variable "lidop_name" {}
variable "user_name" {}
variable "password" {}
variable "workers" { }
variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "amis" {
  type = "map"

  default = {
    "eu-central-1" = "ami-0c6e204396d55eeec"
    "us-west-2"    = "ami-0000000"
  }
}

variable public_key {}
variable "private_key" {}
