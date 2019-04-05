provider "openstack" {
  user_name   = "${var.openstack_user_name}"
  tenant_name = "${var.openstack_tenant_name}"
  password    = "${var.openstack_pasword}"
  auth_url    = "${var.openstack_auth_url}"
  insecure    = "true"
}

module "private_key" {
  source = "./../modules/private_key"
}

module "provisioner" {
  source             = "./../modules/provisioner"
  user_name          = "${var.user_name}"
  password           = "${var.password}"
  workers            = "${var.workers}"
  private_key        = "${module.private_key.private_key}"
  worker_public_ips  = "${openstack_networking_floatingip_v2.floating_ip_worker.*.address}"
  master_public_ip   = "${openstack_networking_floatingip_v2.floating_ip_master.*.address}"
  worker_private_ips = "${openstack_compute_instance_v2.worker.*.network.0.fixed_ip_v4}"
  master_private_ip  = "${openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4}"
  dns_recursor    = "${var.dns_nameservers[0]}"
}
