data "azurerm_key_vault" "example" {
  name                = "teste-bridgez"
  resource_group_name = var.resource_group_name
}


data "azurerm_key_vault_secret" "powergate_token" {
  name         = "powergate-token"
  key_vault_id = data.azurerm_key_vault.example.id
}

resource "azurerm_container_group" "example" {
  name                = "example-continst"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "powergate"
    image  = "jofreis/powergate:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      POWERGATE_IP    = var.powergate_ip
      POWERGATE_TOKEN = data.azurerm_key_vault_secret.powergate_token.value
    }
  }

  tags = {
    environment = "testing"
  }
}
