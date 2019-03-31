resource "aws_key_pair" "lidop_key" {
  count           = "${var.enabled}"
  key_name_prefix = "lidop_key_${var.lidop_name}_"
  public_key      = "${file("${path.root}/../../temp_key.pub")}"
}

resource "aws_instance" "master" {
  connection {
    user        = "${lookup(var.ssh_users, var.aws_region)}"
    private_key = "${var.private_key}"
  }

  count                  = "${var.enabled}"
  instance_type          = "${var.instance_type_master}"
  ami                    = "${lookup(var.amis, var.aws_region)}"
  key_name               = "${aws_key_pair.lidop_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false

  root_block_device {
    volume_size = "100"
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.lidop_name}-lidop-master"
  }
}

resource "aws_instance" "worker" {
  connection {
    user        = "${lookup(var.ssh_users, var.aws_region)}"
    private_key = "${var.private_key}"
  }

  depends_on = ["aws_instance.master"]

  count                  = "${var.enabled * var.workers}"
  instance_type          = "${var.instance_type_worker}"
  ami                    = "${lookup(var.amis, var.aws_region)}"
  key_name               = "${aws_key_pair.lidop_key.key_name}"
  vpc_security_group_ids = ["${aws_security_group.aws_lidop.id}"]
  subnet_id              = "${aws_subnet.default1.id}"
  source_dest_check      = false

  root_block_device {
    volume_size = "100"
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.lidop_name}-lidop-worker-${count.index}"
  }
}
