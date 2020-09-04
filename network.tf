
resource "libvirt_network" "vm_network" {
  name      = "vm_network"
  domain    = "virt.local"
  addresses = ["192.168.124.0/24"]
  dns {
    enabled    = true
    local_only = true
  }
}
