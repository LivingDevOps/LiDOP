variable "lidop_name" {}

variable "workers" {}

variable "access_key" {}

variable "secret_key" {}

variable "aws_region" {}

variable "private_key" {}

variable "instance_type_master" {
  default = "t2.xlarge"
}

variable "instance_type_worker" {
  default = "t2.large"
}

variable "amis" {
  type = "map"

  default = {
    "eu-central-1" = "ami-0c6e204396d55eeec"
    "eu-other-1"   = "ami-00000"
  }
}

variable "ssh_users" {
  type = "map"

  default = {
    "eu-central-1" = "ubuntu"
    "eu-other-1"   = "ubuntu"
  }
}

variable "enabled" {
  default = 0
}
