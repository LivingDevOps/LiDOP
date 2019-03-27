terraform {
  backend "s3" {
    bucket = "lidopterraform"
    key    = "commonstate"
    region = "eu-central-1"
  }
}

resource "null_resource" "create_temp_ssh_key" {
  provisioner "local-exec" {
    command    = "del ${path.module}\\.temp_key"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command    = "del ${path.module}\\.temp_key.pub"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command    = "rm ${path.module}/.temp_key"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command    = "rm ${path.module}/.temp_key.pub"
    on_failure = "continue"
  }

  provisioner "local-exec" {
    command = "ssh-keygen -f ${path.module}/.temp_key -t rsa -N ''"
  }
}

data "local_file" "private_key" {
  filename   = "${path.module}/.temp_key"
  depends_on = ["null_resource.create_temp_ssh_key"]
}

data "local_file" "public_key" {
  filename   = "${path.module}/.temp_key.pub"
  depends_on = ["null_resource.create_temp_ssh_key"]
}

module "aws_lidop" {
  source      = "./modules/lidop"
  lidop_name  = "${var.lidop_name}"
  user_name   = "${var.user_name}"
  password    = "${var.password}"
  workers     = "${var.workers}"
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  public_key  = "${data.local_file.public_key.content}"
  private_key = "${data.local_file.private_key.content}"
  region      = "${var.region}"
}

output "public_ip" {
  value = "${module.aws_lidop.public_ip}"
}
