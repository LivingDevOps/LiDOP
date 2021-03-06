resource "aws_vpc" "aws_lidop" {
  count      = "${var.enabled}"
  cidr_block = "172.10.0.0/16"
}

resource "aws_internet_gateway" "default" {
  count  = "${var.enabled}"
  vpc_id = "${aws_vpc.aws_lidop.id}"
}

resource "aws_route" "internet_access" {
  count                  = "${var.enabled}"
  route_table_id         = "${aws_vpc.aws_lidop.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default1" {
  count                   = "${var.enabled}"
  vpc_id                  = "${aws_vpc.aws_lidop.id}"
  cidr_block              = "172.10.10.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "aws_lidop" {
  count       = "${var.enabled}"
  name        = "${var.lidop_name}-${terraform.workspace}-LiDOP"
  description = "${var.lidop_name}-${terraform.workspace}-LiDOP"
  vpc_id      = "${aws_vpc.aws_lidop.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 8
    to_port   = 0
    protocol  = "icmp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
