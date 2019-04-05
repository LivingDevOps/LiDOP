resource "openstack_compute_keypair_v2" "lidop_key" {
  count      = "${var.enabled}"
  name       = "lidop_key_${var.lidop_name}"
  public_key = "${module.private_key.public_key}"
}

resource "openstack_compute_instance_v2" "master" {
  count             = "${var.enabled}"
  name              = "${var.lidop_name}-lidop-master"
  image_name        = "${var.image_name}"
  availability_zone = "${var.availability_zone}"
  flavor_name       = "${var.instance_type_master}"
  key_pair          = "${openstack_compute_keypair_v2.lidop_key.name}"
  security_groups   = ["${openstack_compute_secgroup_v2.security.name}"]
  user_data         = "package_update: false; package_upgrade: false"

  network {
    uuid = "${openstack_networking_network_v2.network.id}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip_master" {
  count       = "${var.enabled}"
  floating_ip = "${openstack_networking_floatingip_v2.floating_ip_master.address}"
  instance_id = "${openstack_compute_instance_v2.master.id}"
}

resource "openstack_compute_instance_v2" "worker" {
  count             = "${var.enabled * var.workers}"
  name              = "${var.lidop_name}-lidop-worker-${count.index}"
  image_name        = "${var.image_name}"
  availability_zone = "${var.availability_zone}"
  flavor_name       = "${var.instance_type_master}"
  key_pair          = "${openstack_compute_keypair_v2.lidop_key.name}"
  security_groups   = ["${openstack_compute_secgroup_v2.security.name}"]

  network {
    uuid = "${openstack_networking_network_v2.network.id}"
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip_worker" {
  count       = "${var.enabled * var.workers}"
  floating_ip = "${element(openstack_networking_floatingip_v2.floating_ip_worker.*.address, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.worker.*.id, count.index)}"
}
