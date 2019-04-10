output "worker_public_ips" {
  value = "${openstack_networking_floatingip_v2.floating_ip_worker.*.address}"
}

output "master_public_ip" {
  value = "${openstack_networking_floatingip_v2.floating_ip_master.*.address}"
}

output "worker_private_ips" {
  value = "${openstack_compute_instance_v2.worker.*.network.0.fixed_ip_v4}"
}

output "master_private_ip" {
  value = "${openstack_compute_instance_v2.master.*.network.0.fixed_ip_v4}"
}
