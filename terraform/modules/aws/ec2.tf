// resource "aws_instance" "example" {
//   ami           = "${lookup(var.amis, var.region)}"
//   instance_type = "t2.micro"
// }

resource "aws_instance" "master" {
  connection {
    user        = "ubuntu"
    private_key = "${file("${var.private_key}")}"
  }

  instance_type          = "t2.medium"
  ami                    = "${lookup(var.amis, var.region)}"
  key_name               = "${var.private_key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false
  private_ip             = "172.10.10.10"

provisioner "remote-exec" {
    inline = [
      "sudo mkdir /vagrant",
      "sudo chmod -R 777 /vagrant",
    ]
  }
  provisioner "file" {
    source      = "./../.lidop_config.yaml"
    destination = "/vagrant/.lidop_config.yaml"
  }

  provisioner "file" {
    source      = "./../install"
    destination = "/vagrant/install/"
  }

  provisioner "file" {
    source      = "./../configs"
    destination = "/vagrant/configs/"
  }
  provisioner "file" {
    source      = "./../plugins"
    destination = "/vagrant/plugins/"
  }

  provisioner "file" {
    source      = "./../tests"
    destination = "/vagrant/tests/"
  }

  provisioner "remote-exec" {
    scripts      = [
      "./../scripts/ansible.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "export ANSIBLE_CONFIG=/vagrant/install/ansible.cfg",
      "echo start ansible",
      "sudo ansible-playbook -v /vagrant/install/install.yml -e ' ",
      "root_password=lidop" ,
      "root_user=lidop",
      "node=master '"
    ]
  }

  tags = {
    Name = "lidop-master"
  }
}

// resource "aws_instance" "chrome" {
//   connection {
//     user = "ubuntu"
//     private_key = "${file("${var.private_key}")}"
//   }


//   count = "${var.count}"


//   instance_type = "t2.medium"
//   ami = "ami-0c6e204396d55eeec"
//   key_name = "${var.private_key_name}"
//   vpc_security_group_ids = ["${aws_security_group.aws_demo.id}"]
//   subnet_id = "${aws_subnet.default1.id}"


//   provisioner "file" {
//     source      = "./Docker"
//     destination = "/tmp/Docker"
//   }


//   provisioner "remote-exec" {
//     inline = [
//       "sudo apt-get -y update",
//       "sudo bash /tmp/Docker/install.sh",
//       "sudo sudo ip route add 10.20.30.0/24 via 172.10.10.10 dev eth0",
//       "sudo docker run -d -e HUB_HOST=10.20.30.40 -e HUB_PORT=8091 -e REMOTE_HOST=http://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):5550 -p 5550:5555 selenium/node-chrome",
//       "sudo docker run -d -e HUB_HOST=10.20.30.40 -e HUB_PORT=8091 -e REMOTE_HOST=http://$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4):5551 -p 5551:5555 selenium/node-chrome"
//     ]
//   }


//   tags = { 
//     Name = "selenium-client"
//   }
// }

