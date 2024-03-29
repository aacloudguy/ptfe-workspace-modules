variable "name" {}
variable "location" {}
variable "username" {}
variable "password" {}

variable "vnet_address_spacing" {
  type = "list"
}

variable "subnet_address_prefixes" {
  type = "list"
}

module "networking" {
  source  = "aa-training.digitalinnovation.dev/tomwaa1/networking/azurerm"
  version = "0.0.1"
  
  name                    = "${var.name}"
  location                = "${var.location}"
  vnet_address_spacing    = "${var.vnet_address_spacing}"
  subnet_address_prefixes = "${var.subnet_address_prefixes}"
}

module "webserver" {
  source  = "aa-training.digitalinnovation.dev/tomwaa1/webserver/azurerm"
  version = "0.0.1"

  name      = "${var.name}"
  location  = "${var.location}"
  subnet_id = "${module.networking.subnet-ids[0]}"
  count     = 2
  username  = "${var.username}"
  password  = "${var.password}"
}

output "networking_vnet" {
  value = "${module.networking.virtualnetwork-ids}"
}

output "networking_subnets" {
  value = "${module.networking.subnet-ids}"
}

output "webserver-vm-ids" {
  value = "${module.webserver.vm-ids}"
}

output "webserver-private-ips" {
  value = "${module.webserver.private-ips}"
}
