resource "aws_key_pair" "lidop_key" {
  key_name   = "${var.lidop_name}_lidop_key"
  public_key = "${var.public_key}"
}

resource "aws_instance" "master" {
  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  instance_type          = "t2.xlarge"
  ami                    = "${lookup(var.amis, var.region)}"
  key_name               = "${var.lidop_name}_lidop_key"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false
  private_ip             = "172.10.10.10"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
    volume_type = "gp2"
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
      "sudo docker run --rm -v /vagrant/tests/:/serverspec -v /var/lidop/www/tests/:/var/lidop/www/tests/ -e USERNAME=${var.user_name} -e PASSWORD=${var.password} -e HOST=${aws_instance.master.private_ip} -e HOSTNAME=${aws_instance.master.private_ip} -e TEST_HOST=master registry.service.lidop.local:5000/lidop/serverspec:latest test",
    ]
  }

  tags = {
    Name = "${var.lidop_name}_lidop-master"
  }
}


resource "aws_instance" "worker" {
  depends_on = ["aws_instance.master"]

  count = "${var.workers}"

  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  instance_type          = "t2.xlarge"
  ami                    = "${lookup(var.amis, var.region)}"
  key_name               = "lidop_key"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
    volume_type = "gp2"
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
      "consul_ip=${aws_instance.master.private_ip}",
      "install_mode=online'",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker run --rm -v /vagrant/tests/:/serverspec -v /var/lidop/www/tests/:/var/lidop/www/tests/ -e USERNAME=${var.user_name} -e PASSWORD=${var.password} -e HOST=${aws_instance.master.private_ip} -e HOSTNAME=${aws_instance.master.private_ip} -e TEST_HOST=master registry.service.lidop.local:5000/lidop/serverspec:latest test",
    ]
  }

  tags = {
    Name = "lidop-worker"
  }
}