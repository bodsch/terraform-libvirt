

variable "domain"   { default = "virt.local" }
variable "prefixIP" { default = "192.168.124" }

# Use CloudInit to add our ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {

  for_each = var.servers

  name           = "common_build_${each.key}.iso"
  pool           = "default"
  user_data      = data.template_file.user_data[ each.key ].rendered
  network_config = data.template_file.network_config[ each.key ].rendered
}

data "template_file" "user_data" {

  for_each = var.servers

  template = "${file("${path.module}/cloud_init.cfg")}"

  vars = {
    domain   = var.domain
    hostname = var.servers[ each.key ].hostname
    fqdn     = join(".", [var.servers[ each.key ].hostname, var.domain])

    prefixIP = var.prefixIP
    octetIP  = var.servers[ each.key ].octetIP
  }
}


data "template_file" "network_config" {

  for_each = var.servers

  template = file("${path.module}/network_config_static.cfg")

  vars = {
    domain   = var.domain
    hostname = var.servers[ each.key ].hostname
    fqdn     = join(".", [var.servers[ each.key ].hostname, var.domain])

    prefixIP = var.prefixIP
    octetIP  = var.servers[ each.key ].octetIP
  }
}

/** virtual machines **/
resource "libvirt_domain" "host" {

  for_each = var.servers

  name   = lookup( var.servers[ each.key ], "hostname" )
  memory = lookup( var.servers[ each.key ], "memory" )
  vcpu   = lookup( var.servers[ each.key ], "vcpu" )

  disk { volume_id = libvirt_volume.diskimage[each.key].id }

  network_interface {
    network_name = "vm_network"
  }

  boot_device { dev = [ "cdrom", "hd" ] }

  cloudinit = libvirt_cloudinit_disk.commoninit[ each.key ].id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }

}
