terraform {
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.27.0"
    }
  }
}

provider "esxi" {
  esxi_hostname = "192.168.1.3"
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = "Welkom01!"
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id = "c064671c-8f74-4fec-b088-b53c568245eb"
  features {}
}
