terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.63.0"
    }
  }
 
  cloud {
    organization = "SNOW-1"
    workspaces {
      name = "Azure-poc-"
    }
  }
}
 
provider "azurerm" {
  features {}
}