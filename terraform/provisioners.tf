resource "null_resource" "master-bootstrap" {
  count = "1"

  connection {
    host        = "${element(concat(module.aws.master_public_ip, module.azure.master_public_ip), count.index)}"
    user        = "ubuntu"
    private_key = "${module.private_key.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /vagrant",
      "sudo chmod -R 777 /vagrant",
    ]
  }

  provisioner "file" {
    source      = "./templates/lidop_config.yaml"
    destination = "/vagrant/.lidop_config.yaml"
  }

  provisioner "file" {
    source      = "./lidop_config.yaml"
    destination = "/vagrant/.lidop_config.yaml"
    on_failure  = "continue"
  }

  provisioner "file" {
    source      = "./install"
    destination = "/vagrant/install/"
  }

  provisioner "file" {
    source      = "./configs"
    destination = "/vagrant/configs/"
  }

  provisioner "file" {
    source      = "./plugins"
    destination = "/vagrant/plugins/"
  }

  provisioner "file" {
    source      = "./tests"
    destination = "/vagrant/tests/"
  }

  provisioner "file" {
    source      = "./extensions"
    destination = "/vagrant/extensions/"
  }

  provisioner "remote-exec" {
    scripts = [
      "./scripts/ansible.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_CONFIG=/vagrant/install/ansible.cfg",
      "export ANSIBLE_VAULT_PASSWORD=${var.password}",
      "echo start ansible",
      "sudo ansible-playbook -v /vagrant/install/install.yml -e ' ",
      "root_password=${var.password}",
      "root_user=${var.user_name}",
      "node=master",
      "install_mode=online'",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run --rm -v /vagrant/tests/:/serverspec -v /var/lidop/www/tests/:/var/lidop/www/tests/ -e USERNAME=${var.user_name} -e PASSWORD=${var.password} -e HOST=${element(concat(module.aws.master_private_ip, module.azure.master_private_ip), count.index)} -e HOSTNAME=${element(concat(module.aws.master_private_ip, module.azure.master_private_ip), count.index)} -e TEST_HOST=master registry.service.lidop.local:5000/lidop/serverspec:latest test",
    ]
  }
}

resource "null_resource" "worker-bootstrap" {
  count      = "${var.workers}"
  depends_on = ["null_resource.master-bootstrap"]

  connection {
    host        = "${element(concat(module.aws.worker_public_ips, module.azure.worker_public_ips), count.index)}"
    user        = "ubuntu"
    private_key = "${module.private_key.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /vagrant",
      "sudo chmod -R 777 /vagrant",
    ]
  }

  provisioner "file" {
    source      = "./templates/lidop_config.yaml"
    destination = "/vagrant/.lidop_config.yaml"
  }

  provisioner "file" {
    source      = "./lidop_config.yaml"
    destination = "/vagrant/.lidop_config.yaml"
    on_failure  = "continue"
  }

  provisioner "file" {
    source      = "./install"
    destination = "/vagrant/install/"
  }

  provisioner "file" {
    source      = "./configs"
    destination = "/vagrant/configs/"
  }

  provisioner "file" {
    source      = "./plugins"
    destination = "/vagrant/plugins/"
  }

  provisioner "file" {
    source      = "./tests"
    destination = "/vagrant/tests/"
  }

  provisioner "file" {
    source      = "./extensions"
    destination = "/vagrant/extensions/"
  }

  provisioner "remote-exec" {
    scripts = [
      "./scripts/ansible.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_CONFIG=/vagrant/install/ansible.cfg",
      "export ANSIBLE_VAULT_PASSWORD=${var.password}",
      "echo start ansible",
      "sudo ansible-playbook -v /vagrant/install/install.yml -e ' ",
      "root_password=${var.password}",
      "root_user=${var.user_name}",
      "node=worker",
      "consul_ip=${element(concat(module.aws.master_private_ip, module.azure.master_private_ip), count.index)}",
      "install_mode=online'",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run --rm -v /vagrant/tests/:/serverspec -v /var/lidop/www/tests/:/var/lidop/www/tests/ -e USERNAME=${var.user_name} -e PASSWORD=${var.password} -e HOST=${element(concat(module.aws.worker_private_ips, module.azure.worker_private_ips), count.index)} -e HOSTNAME=${element(concat(module.aws.worker_private_ips, module.azure.worker_private_ips), count.index)} -e TEST_HOST=worker registry.service.lidop.local:5000/lidop/serverspec:latest test",
    ]
  }
}
