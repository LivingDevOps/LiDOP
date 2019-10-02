variable "user_name" {
  default = "lidop"
}

variable "password" {}

variable "lidop_name" {}

variable "workers" {
  default = 0
}

variable enabled {
  default = "1"
}

variable vra_username {}
variable vra_password {}

variable ssh_username {}
variable ssh_password {}

variable tenant {}
variable host {}
variable image_name {}

variable "instance_count" {
  default = 1
}

variable "catalog_id" {
  type = "map"

  default = {
    "Ubuntu16"         = "00000000-0000-0000-0000-000000000000"
  }
}

variable "dns_nameservers" {
  default = ["8.8.8.8", "8.8.4.4"]
}
