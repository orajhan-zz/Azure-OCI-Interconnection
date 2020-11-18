# Create a resource group
resource "azurerm_resource_group" "AzureRG" {
  name     = "${var.prefix}-RG"
  location = var.location.Tokyo
}
