variable "user_name" {}

variable "password" {}

variable "private_key" {
    default = ""
}
variable "ssh_user" {
  default = "ubuntu"
}
variable "ssh_password" {
  default = ""
}

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

variable "dns_recursor" {
  default = "8.8.8.8"
}
