// terraform {
//   backend "s3" {
//     bucket = "lidopterraform"
//     key    = "commonstate"
//     region = "eu-central-1"
//   }
// }

// module "private_key" {
//   source = "./modules/private_key"
// }

// module "aws" {
//   source     = "./modules/aws"
//   enabled    = "${var.cloud == "aws" ? 1 : 0}"
//   lidop_name = "${var.lidop_name}"
//   workers    = "${var.workers}"
//   access_key = "${var.access_key}"
//   secret_key = "${var.secret_key}"

//   private_key = "${module.private_key.private_key}"
//   aws_region      = "${var.aws_region}"
// }

// module "azure" {
//   source          = "./modules/azure"
//   enabled         = "${var.cloud == "azure" ? 1 : 0}"
//   subscription_id = "${var.subscription_id}"
//   client_id       = "${var.client_id}"
//   client_secret   = "${var.client_secret}"
//   tenant_id       = "${var.tenant_id}"
//   workers         = "${var.workers}"
//   lidop_name      = "${var.lidop_name}"
//   azure_region    = "${var.azure_region}"
// }

// output "worker_public_ips" {
//   value = "${concat(module.aws.worker_public_ips, module.azure.worker_public_ips)}"
// }

// output "master_public_ip" {
//   value = "${concat(module.aws.master_public_ip, module.azure.master_public_ip)}"
// }
