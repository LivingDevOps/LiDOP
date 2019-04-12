resource "null_resource" "master-bootstrap" {
  count = "1"

  connection {
    host        = "${element(var.master_public_ip, count.index)}"
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo *******************************************************************",
      "echo *******************************************************************",
      "echo master ${element(var.master_public_ip, count.index)}",
      "echo *******************************************************************",
      "echo *******************************************************************",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /tmp/lidop",
      "sudo chmod -R 777 /tmp/lidop",
    ]
  }

  provisioner "file" {
    source      = "./templates/lidop_config.yaml"
    destination = "/tmp/lidop/.lidop_config.yaml"
  }

  provisioner "file" {
    source      = "./.lidop_config.yaml"
    destination = "/tmp/lidop/.lidop_config.yaml"
    on_failure  = "continue"
  }

  provisioner "file" {
    source      = "./build"
    destination = "/tmp/lidop/build/"
  }

  provisioner "file" {
    source      = "./install"
    destination = "/tmp/lidop/install/"
  }

  provisioner "file" {
    source      = "./templates"
    destination = "/tmp/lidop/templates/"
  }

  provisioner "file" {
    source      = "./configs"
    destination = "/tmp/lidop/configs/"
  }

  provisioner "file" {
    source      = "./plugins"
    destination = "/tmp/lidop/plugins/"
  }

  provisioner "file" {
    source      = "./scripts"
    destination = "/tmp/lidop/scripts/"
  }

  provisioner "file" {
    source      = "./terraform"
    destination = "/tmp/lidop/terraform/"
  }

  provisioner "file" {
    source      = "./tests"
    destination = "/tmp/lidop/tests/"
  }

  provisioner "file" {
    source      = "./extensions"
    destination = "/tmp/lidop/extensions/"
  }

  provisioner "remote-exec" {
    scripts = [
      "./scripts/ansible.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/lidop/install/vault-env",
      "export ANSIBLE_CONFIG=/tmp/lidop/install/ansible.cfg",
      "export ANSIBLE_VAULT_PASSWORD=${var.password}",
      "echo start ansible",
      "ansible-playbook -v /tmp/lidop/install/install.yml --vault-password-file /tmp/lidop/install/vault-env -e ' ",
        "root_password=${var.password}",
        "root_user=${var.user_name}",
        "node=master",
        "public_ipaddress=${element(var.master_public_ip, count.index)}",
        "ipaddress=${element(var.master_private_ip, count.index)}",
        "install_mode=online",
        "dns_recursor=${var.dns_recursor}'",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run --rm -v /tmp/lidop/tests/:/serverspec -v /var/lidop/www/tests/:/var/lidop/www/tests/ -e USERNAME=${var.user_name} -e PASSWORD=${var.password} -e HOST=${element(var.master_private_ip, count.index)} -e HOSTNAME=${element(var.master_private_ip, count.index)} -e TEST_HOST=master registry.service.lidop.local:5000/lidop/serverspec:latest test",
    ]
  }
}

resource "null_resource" "worker-bootstrap" {
  count      = "${var.workers}"
  depends_on = ["null_resource.master-bootstrap"]

  connection {
    host        = "${element(var.worker_public_ips, count.index)}"
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo *******************************************************************",
      "echo *******************************************************************",
      "echo worker ${element(var.worker_public_ips, count.index)}",
      "echo *******************************************************************",
      "echo *******************************************************************",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /tmp/lidop",
      "sudo chmod -R 777 /tmp/lidop",
    ]
  }

  provisioner "file" {
    source      = "./templates/lidop_config.yaml"
    destination = "/tmp/lidop/.lidop_config.yaml"
  }

  provisioner "file" {
    source      = "./.lidop_config.yaml"
    destination = "/tmp/lidop/.lidop_config.yaml"
    on_failure  = "continue"
  }

  provisioner "file" {
    source      = "./build"
    destination = "/tmp/lidop/build/"
  }

  provisioner "file" {
    source      = "./install"
    destination = "/tmp/lidop/install/"
  }

  provisioner "file" {
    source      = "./templates"
    destination = "/tmp/lidop/templates/"
  }

  provisioner "file" {
    source      = "./configs"
    destination = "/tmp/lidop/configs/"
  }

  provisioner "file" {
    source      = "./plugins"
    destination = "/tmp/lidop/plugins/"
  }

  provisioner "file" {
    source      = "./scripts"
    destination = "/tmp/lidop/scripts/"
  }

  provisioner "file" {
    source      = "./terraform"
    destination = "/tmp/lidop/terraform/"
  }

  provisioner "file" {
    source      = "./tests"
    destination = "/tmp/lidop/tests/"
  }

  provisioner "file" {
    source      = "./extensions"
    destination = "/tmp/lidop/extensions/"
  }

  provisioner "remote-exec" {
    scripts = [
      "./scripts/ansible.sh",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/lidop/install/vault-env",
      "export ANSIBLE_CONFIG=/tmp/lidop/install/ansible.cfg",
      "export ANSIBLE_VAULT_PASSWORD=${var.password}",
      "echo start ansible",
      "ansible-playbook -v /tmp/lidop/install/install.yml --vault-password-file /tmp/lidop/install/vault-env -e ' ",
        "root_password=${var.password}",
        "root_user=${var.user_name}",
        "node=worker",
        "public_ipaddress=${element(var.worker_public_ips, count.index)}",
        "ipaddress=${element(var.worker_private_ips, count.index)}",
        "consul_ip=${element(var.master_private_ip, count.index)}",
        "install_mode=online",
        "dns_recursor=${var.dns_recursor}'",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run --rm -v /tmp/lidop/tests/:/serverspec -v /var/lidop/www/tests/:/var/lidop/www/tests/ -e USERNAME=${var.user_name} -e PASSWORD=${var.password} -e HOST=${element(var.worker_private_ips, count.index)} -e HOSTNAME=${element(var.worker_private_ips, count.index)} -e TEST_HOST=worker registry.service.lidop.local:5000/lidop/serverspec:latest test",
    ]
  }
}
