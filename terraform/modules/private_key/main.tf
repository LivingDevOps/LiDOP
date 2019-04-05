resource "null_resource" "create_temp_ssh_key" {
  provisioner "local-exec" {
    command    = "del ${path.root}\\.${var.name}"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command    = "del ${path.root}\\.${var.name}.pub"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command    = "rm ${path.root}/.${var.name}"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command    = "rm ${path.root}/.${var.name}.pub"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command = "ssh-keygen -f ${path.root}/.${var.name} -t rsa -N ''"
  }
}

data "local_file" "private_key" {
  filename   = "${path.root}/.${var.name}"
  depends_on = ["null_resource.create_temp_ssh_key"]
}

data "local_file" "public_key" {
  filename   = "${path.root}/.${var.name}.pub"
  depends_on = ["null_resource.create_temp_ssh_key"]
}
