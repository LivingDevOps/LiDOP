resource "openstack_networking_network_v2" "network" {
  count          = "${var.enabled}"
  name           = "rmd_net"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "sub_1" {
  count           = "${var.enabled}"
  name            = "rmd_net_sub1"
  network_id      = "${openstack_networking_network_v2.network.id}"
  cidr            = "172.10.1.0/24"
  ip_version      = 4
  dns_nameservers ="${var.dns_nameservers}"
}

resource "openstack_networking_router_v2" "router" {
  count               = "${var.enabled}"
  name                = "rmd_router"
  admin_state_up      = "true"
  external_network_id = "2299dedd-216f-4ef9-8805-c2685cbfa4d2"
}

resource "openstack_networking_router_interface_v2" "router" {
  count     = "${var.enabled}"
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.sub_1.id}"
}

resource "openstack_compute_secgroup_v2" "rmd_security" {
  count       = "${var.enabled}"
  name        = "rmd_security"
  description = "rmd_security"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_floatingip_v2" "floating_ip_master" {
  count = "${var.enabled}"
  pool  = "GATEWAY_NET"
}

resource "openstack_networking_floatingip_v2" "floating_ip_worker" {
  count = "${var.enabled * var.workers}"
  pool  = "GATEWAY_NET"
}
