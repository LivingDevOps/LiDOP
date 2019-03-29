########################################################
# ONLY COPY PASTE FROM AWS. AZURE IS NOT IMPLEMENTET
########################################################

resource "aws_key_pair" "lidop_key" {
  count = "${var.enabled}"
  key_name_prefix   = "lidop_key_${var.lidop_name}_"
  // public_key = "${var.public_key}"
  public_key = "${file("${path.root}/temp_key.pub")}"
}

resource "aws_instance" "master" {
  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }

  // count = "${var.enabled}"
  count=0
  instance_type          = "t2.large"
  ami                    = "${lookup(var.amis, var.region)}"
  key_name               = "${aws_key_pair.lidop_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false
  // private_ip             = "172.10.10.10"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
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
    Name = "idop-master"
  }
}

resource "aws_instance" "worker" {
  connection {
    user        = "ubuntu"
    private_key = "${var.private_key}"
  }  
  depends_on = ["aws_instance.master"]


  // count = "${var.enabled * var.workers}"
  count=0
  instance_type          = "t2.large"
  ami                    = "${lookup(var.amis, var.region)}"
  key_name               = "${var.lidop_name}_lidop_key"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false
  // private_ip             = "172.10.10.10"

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 50
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
    Name = "idop-worker-${count.index}"
  }
}