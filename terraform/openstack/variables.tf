variable "openstack_user_name" {}
variable "openstack_tenant_name" {}
variable "openstack_pasword" {}

variable "openstack_auth_url" {}

variable "enabled" {
  default = 1
}

variable "user_name" {
  default = "lidop"
}

variable "password" {}
variable "lidop_name" {}

variable "workers" {
  default = 0
}

variable "image_name" {}

variable "availability_zone" {}

variable "instance_type_master" {
  default = "a1.2large"
}

variable "instance_type_worker" {
  default = "a1.xlarge"
}

variable "dns_nameservers" {
  default = ["8.8.8.8", "8.8.4.4"]
}