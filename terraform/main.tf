module "aws_lidop" {
  source           = "./modules/aws"
  access_key       = "${var.access_key}"
  secret_key       = "${var.secret_key}"
  private_key      = "${var.private_key}"
  private_key_name = "${var.private_key_name}"
  region           = "${var.region}"
}
