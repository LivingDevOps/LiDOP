resource "null_resource" "create_temp_ssh_key" {
  provisioner "local-exec" {
    command    = "del ${path.root}\\temp_key"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command    = "rm ${path.root}/temp_key"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command = "ssh-keygen -f ${path.root}/../temp_key -t rsa -N ''"
  }
}

data "local_file" "private_key" {
  filename   = "${path.root}/temp_key"
  depends_on = ["null_resource.create_temp_ssh_key"]
}
