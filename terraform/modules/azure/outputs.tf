########################################################
# ONLY COPY PASTE FROM AWS. AZURE IS NOT IMPLEMENTET
########################################################

output "worker_public_ips" {
  value = "${aws_instance.worker.*.public_ip}"
}

output "master_public_ip" {
  value = "${aws_instance.master.*.public_ip}"
}

output "worker_private_ips" {
  value = "${aws_instance.worker.*.private_ip}"
}

output "master_private_ip" {
  value = "${aws_instance.master.*.private_ip}"
}

