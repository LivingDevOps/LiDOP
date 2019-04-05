provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

module "private_key" {
  source = "./../modules/private_key"
  name   = "${var.lidop_name}"
}

module "provisioner" {
  source             = "./../modules/provisioner"
  user_name          = "${var.user_name}"
  password           = "${var.password}"
  workers            = "${var.workers}"
  private_key        = "${module.private_key.private_key}"
  worker_public_ips  = "${aws_instance.worker.*.public_ip}"
  master_public_ip   = "${aws_instance.master.*.public_ip}"
  worker_private_ips = "${aws_instance.worker.*.private_ip}"
  master_private_ip  = "${aws_instance.master.*.private_ip}"
}
