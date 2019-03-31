variable "user_name" {}

variable "password" {}

variable "private_key" {}
variable "workers" {
  default = 0
}

variable "worker_public_ips" {
  default = []
}

variable "master_public_ip" {
    default = []
}

variable "worker_private_ips" {
    default = []
}

variable "master_private_ip" {
    default = []
}
