
/** other distributions **/
/*
// centos 7
resource "libvirt_volume" "centos_image" {
  name = "${var.vm_machines[count.index]}.qcow2"
  // name   = "centos-image-7"
  pool   = "default"
  source = "/var/lib/libvirt/images/pool/CentOS-7-x86_64-GenericCloud-1907.qcow2"
}

// ubuntu 1904
resource "libvirt_volume" "ubuntu_1904_image" {
  name = "${var.vm_machines[count.index]}.qcow2"
  // name   = "ubuntu-image-1904"
  pool   = "default"
  source = "/var/lib/libvirt/images/pool/ubuntu-1904-server-cloudimg-amd64.qcow2"
}

// ubuntu 1910
resource "libvirt_volume" "ubuntu_1910_image" {
  name = "${var.vm_machines[count.index]}.qcow2"
  // name   = "ubuntu-image-1910"
  pool   = "default"
  source = "/var/lib/libvirt/images/pool/ubuntu-1910-server-cloudimg-amd64.qcow2"
}
*/

// debian 10
resource "libvirt_volume" "debian_10_image" {
  name     = "debian-image-10"
  pool     = "pool"
  source   = "/var/lib/libvirt/pool/debian-10-amd64.qcow2"

}

resource "libvirt_volume" "diskimage" {

  for_each       = var.servers

  pool           = "default"
  name           = "${each.key}.qcow2"
  base_volume_id = libvirt_volume.debian_10_image.id
  size           = lookup(var.servers[each.key], "disk_size", "") == "" ? "0" : var.servers[each.key].disk_size
}
