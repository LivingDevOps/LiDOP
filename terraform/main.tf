terraform {
  backend "s3" {
    bucket = "lidopterraform"
    key    = "commonstate"
    region = "eu-central-1"
  }
}

module "private_key" {
  source = "./modules/private_key"
}

module "aws" {
  source     = "./modules/aws"
  enabled    = "${var.cloud == "aws" ? 1 : 0}"
  lidop_name = "${var.lidop_name}"
  user_name  = "${var.user_name}"
  password   = "${var.password}"
  workers    = "${var.workers}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"

  private_key = "${module.private_key.private_key}"
  region      = "${var.region}"
}

module "azure" {
  source     = "./modules/azure"
  enabled    = "${var.cloud == "azure" ? 1 : 0}"
  lidop_name = "${var.lidop_name}"
  user_name  = "${var.user_name}"
  password   = "${var.password}"
  workers    = "${var.workers}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"

  private_key = "${module.private_key.private_key}"
  region      = "${var.region}"
}

output "worker_public_ips" {
  value = "${concat(module.aws.worker_public_ips, module.azure.worker_public_ips)}"
}

output "master_public_ip" {
  value = "${concat(module.aws.master_public_ip, module.azure.master_public_ip)}"
}
