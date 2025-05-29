#Esxi
resource "esxi_guest" "LAB6VM" {
  guest_name     = "LAB6VM"  
  disk_store     = "Datastore1"
  ovf_source     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"  # Ubuntu Cloud Image

  network_interfaces {
    virtual_network = "VM Network"          
  }
}