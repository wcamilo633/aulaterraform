terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}
 
provider "azurerm" {
  features {}
 
  # Boa prática, especificar a subscrição que se vai trabalhar
  subscription_id = "0c0ab4e7-8886-47f6-920f-600720198728"
}
