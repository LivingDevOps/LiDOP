variable "lidop_name" {
  default = "lidop_demo"
}

variable "user_name" {
  default = "lidop"
}

variable "password" {}

variable "cloud" {
  default = "aws"
}

variable "workers" {
  default = 0
}

variable "access_key" {}
variable "secret_key" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "azure_region" {
  default = "West Europe"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
