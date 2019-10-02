provider "vra7" {
  username = "${var.vra_username}"
  password = "${var.vra_password}"
  tenant   = "${var.tenant}"
  host     = "${var.host}"
  insecure = true
}

# module "private_key" {
#   source = "./../modules/private_key"
#   name   = "${var.lidop_name}"
# }

module "provisioner" {
  source       = "./../modules/provisioner"
  user_name    = "${var.user_name}"
  password     = "${var.password}"
  workers      = "${var.workers}"
  ssh_user     = "${var.ssh_username}"
  ssh_password = "${var.ssh_password}"

  worker_public_ips  = "${vra7_deployment.worker.*.resource_configuration.Machine.ip_address}"
  master_public_ip   = "${vra7_deployment.master.*.resource_configuration.Machine.ip_address}"
  worker_private_ips = "${vra7_deployment.worker.*.resource_configuration.Machine.ip_address}"
  master_private_ip  = "${vra7_deployment.master.*.resource_configuration.Machine.ip_address}"
  dns_recursor       = "${var.dns_nameservers[0]}"}
