# resource "aws_key_pair" "lidop_key" {
#   count           = "${var.enabled}"
#   key_name_prefix = "lidop_key_${var.lidop_name}-${terraform.workspace}_"
#   public_key      = "${module.private_key.public_key}"
# }

resource "vra7_deployment" "master" {

  catalog_item_id = "${lookup(var.catalog_id, "Ubuntu16")}"
  count           = "${var.enabled}"
  reasons         = "${var.lidop_name}-${terraform.workspace}-lidop-master"
  description     = "${var.lidop_name}-${terraform.workspace}-lidop-master"

  resource_configuration = {
    Machine.ip_address = ""
    Machine.name = ""
  }
}

resource "vra7_deployment" "worker" {

  catalog_item_id = "${lookup(var.catalog_id, "Ubuntu16")}"
  count           = "${var.enabled * var.workers}"
  reasons         = "${var.lidop_name}-${terraform.workspace}-lidop-worker-${count.index}"
  description     = "${var.lidop_name}-${terraform.workspace}-lidop-worker-${count.index}"

  resource_configuration = {
    Machine.ip_address = ""
    Machine.name = ""
  }
}
