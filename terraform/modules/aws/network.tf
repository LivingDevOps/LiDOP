# Create a VPC to launch our instances into
resource "aws_vpc" "aws_lidop" {
  cidr_block = "172.10.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.aws_lidop.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.aws_lidop.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default1" {
  vpc_id                  = "${aws_vpc.aws_lidop.id}"
  cidr_block              = "172.10.10.0/24"
  map_public_ip_on_launch = true
}

// # Create a subnet to launch our instances into
// resource "aws_subnet" "default2" {
//   vpc_id                  = "${aws_vpc.aws_lidop.id}"
//   cidr_block              = "172.10.21.0/24"
//   map_public_ip_on_launch = true
// }

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "aws_lidop" {
  name        = "AWS-Demo"
  description = "AWS-Demo"
  vpc_id      = "${aws_vpc.aws_lidop.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from the VPC
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

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
