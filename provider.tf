terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.60"
    }
  }
  backend "azurerm" {
    # with SAS token
    storage_account_name = "mzpoc"                              
    container_name       = "newrelic"                               
    key                  = "newrelic.terraform.tfstate"                
  }
}

provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key = var.newrelic_api_key
  region  = "us"
}