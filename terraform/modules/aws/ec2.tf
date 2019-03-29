resource "aws_key_pair" "lidop_key" {
  count = "${var.enabled}"
  key_name_prefix   = "lidop_key_${var.lidop_name}_"
  public_key = "${file("${path.root}/temp_key.pub")}"
}

resource "aws_instance" "master" {
  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  count = "${var.enabled}"
  instance_type          = "t2.large"
  ami                    = "${lookup(var.amis, var.region)}"
  key_name               = "${aws_key_pair.lidop_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false
  // private_ip             = "172.10.10.10"

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  provisioner "remote-exec" {
    inline = [
      "echo #############################################################################",
      "echo from instance master ${self.public_ip}",
      "echo #############################################################################"
    ]
  }


  tags = {
    Name = "${var.name}-lidop-master"
  }
}

resource "aws_instance" "worker" {
  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }  
  depends_on = ["aws_instance.master"]


  count = "${var.enabled * var.workers}"
  instance_type          = "t2.large"
  ami                    = "${lookup(var.amis, var.region)}"
  key_name               = "${aws_key_pair.lidop_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false
  // private_ip             = "172.10.10.10"

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
  }

  provisioner "remote-exec" {
    inline = [
      "echo #############################################################################",
      "echo from instance worker ${self.public_ip}",
      "echo #############################################################################"
    ]
  }


  tags = {
    Name = "${var.name}-lidop-worker-${count.index}"
  }
}