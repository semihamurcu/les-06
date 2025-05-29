# General variables
variable "resource_group_name" {
  description = "Naam van de resource group"
  type        = string
}

variable "location" {
  description = "Azure regio"
  type        = string
}


variable "ssh_key_path" {
  description = "Pad naar de private SSH key (ED25519). De public key wordt automatisch gezocht via `.pub` extensie."
  type        = string
  default     = "~/.ssh/devhostnieuw"
}

variable "ssh_public_key_path" {
  description = "Pad naar de public SSH key"
  type        = string
  default     = "~/.ssh/devhostnieuw.pub"
}