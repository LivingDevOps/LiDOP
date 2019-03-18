variable "name" {
  default = "lidop"
}

# SSH 
variable "private_key_name" {}

variable "private_key" {}

# AWS
variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "eu-central-1"
}
