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


module "powergate-machine" {
  source              = "./modules/powergate-filecoin"
  resource_group_name = azurerm_resource_group.ipfs.name
  location = "East US"
}






