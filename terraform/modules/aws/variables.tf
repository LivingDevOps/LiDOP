variable "private_key_name" {}
variable "private_key" {}
variable "access_key" {}
variable "secret_key" {}

variable "region" {
  default = "eu-central-1"
}

variable "amis" {
  type = "map"

  default = {
    "eu-central-1" = "ami-0c6e204396d55eeec"
    "us-west-2"    = "ami-0000000"
  }
}
