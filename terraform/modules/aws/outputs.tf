output "public_ip" {
  value = "${aws_instance.master.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.master.private_ip}"
}
