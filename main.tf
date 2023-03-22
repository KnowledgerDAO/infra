terraform {
  required_version = ">= 0.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}


provider "azurerm" {
  features {}
}



resource "azurerm_resource_group" "ipfs" {
  name     = "ipfs_resource_group"
  location = "East US"
}


module "powergate_machine" {
  source              = "./modules/powergate-filecoin"
  resource_group_name = azurerm_resource_group.ipfs.name
  location            = "East US"
}


resource "time_sleep" "wait_15_minutes" {
  depends_on = [module.powergate_machine.instance_ip_addr]

  create_duration = "15m"
}

resource "null_resource" "cluster" {
  depends_on = [
    time_sleep.wait_15_minutes
  ]
  # node ./scripts/set-token/set-token.js
  provisioner "local-exec" {
    command = "node ./scripts/set-token/set-token.js http://${module.powergate_machine.instance_ip_addr}:6002"
    
    
  }
}


module "powergate-rest-middleware" {
  depends_on = [
    null_resource.cluster
  ]
  source              = "./modules/file-uploader-middleware"
  resource_group_name = "bridgez"
  location            = "East US"
  powergate_ip = module.powergate_machine.instance_ip_addr
}
