# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
      
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
    skip_provider_registration = true

}

# Create a resource group
resource "azurerm_resource_group" "dev-rg" {
  name     = "lab-dev-rg"
  location = "South Central US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "dev-vn" {
  name                = "dev-virtual-network"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = azurerm_resource_group.dev-rg.location
  address_space       = ["10.0.0.0/16"]
}
