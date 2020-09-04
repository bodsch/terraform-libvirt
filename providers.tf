
provider "libvirt" {
  uri = "qemu:///system"
}

/** external provider - not yet tested */
provider "libvirt" {
  alias = "blackbox"
  uri   = "qemu+ssh://root@blackbox.matrix.lan/system"
}
