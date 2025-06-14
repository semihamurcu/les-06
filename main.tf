#Esxi
resource "esxi_guest" "LAB6VM" {
  guest_name     = "LAB6VM"  
  disk_store     = "Datastore1"
  ovf_source     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"  # Ubuntu Cloud Image

  network_interfaces {
    virtual_network = "VM Network"          
  }

guestinfo = {
    "metadata"          = base64encode(templatefile("${path.module}/metadata.yaml.tftpl", { hostname = "LAB6VM" }))
    "metadata.encoding" = "base64"
    "userdata"          = filebase64("${path.module}/userdata.yaml")
    "userdata.encoding" = "base64"
  }
}
# Azure - Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-ubuntu"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-ubuntu"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "ubuntu-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "ubuntu-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Azure Ubuntu VM
resource "azurerm_linux_virtual_machine" "azure_vm" {
  name                = "LAB6VM-Azure"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2ats_v2"
  admin_username      = "testuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "testuser"
    public_key = file(var.ssh_public_key_path)
  }

  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}


# Output van IP-adressen
output "esxi_vm_ip" {
  value = esxi_guest.LAB6VM.ip_address
}

output "azure_vm_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

# Ansible Inventory genereren
resource "local_file" "ansible_inventory" {
 depends_on = [
  esxi_guest.LAB6VM,
  azurerm_linux_virtual_machine.azure_vm,
  azurerm_public_ip.public_ip
]

  content = <<EOF
[esxi]
LAB6VM ansible_host=${esxi_guest.LAB6VM.ip_address} ansible_user=testuser ansible_ssh_private_key_file=~/.ssh/devhostnieuw

[azure]
LAB6VM-Azure ansible_host=${azurerm_public_ip.public_ip.ip_address} ansible_user=testuser ansible_ssh_private_key_file=~/.ssh/devhostnieuw
EOF

  filename = "${path.module}/inventory.ini"
}