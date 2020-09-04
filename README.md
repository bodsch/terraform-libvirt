# KVM Provider

## install provider

get acutall provider from [github](https://github.com/dmacvicar/terraform-provider-libvirt/releases)

```
$ cd ~
$ terraform init
Terraform initialized in an empty directory!

$ mkdir -p ~/.terraform.d/plugins/linux_amd64

$ cd ~/.terraform.d/plugins/linux_amd64
$ curl -sL https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.0/terraform-provider-libvirt-0.6.0+git.1569597268.1c8597df.Ubuntu_18.04.amd64.tar.gz > terraform-provider-libvirt.tar.gz
$ tar -xzf terraform-provider-libvirt.tar.gz

$ ~/.terraform.d/plugins/linux_amd64/terraform-provider-libvirt -version
/home/bodsch/.terraform.d/plugins/linux_amd64/terraform-provider-libvirt 0.6.0+git.1569597268.1c8597df
Compiled against library: libvirt 4.0.0
Using library: libvirt 5.5.0
Running hypervisor: QEMU 4.0.0
Running against daemon: 5.5.0
```

### update terraform

#### v0.12 to v.13

```
$ mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
$ mv -v mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
$ rm -rf ~/.terraform.d
$ terraform 0.13upgrade
$ nano versions.tf # see below
$ cat versions.tf
terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.2"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
$ terraform state replace-provider registry.terraform.io/-/libvirt dmacvicar/libvirt
$ terraform init
$ terraform plan
```


## configure KVM / QEMU

check if you are in the `libvirt` group:
```
$ sudo getent group | grep libvirt
```
otherwise add:
```
$ sudo usermod -a -G libvirt $(whoami)
```

change permissions for qemu and restart service:
```
cat << EOF >> /etc/libvirt/qemu.conf
user = "libvirt-qemu"
group = "libvirt"
EOF

$ service libvirtd restart
```

## Cloud Images

You can find varios cloud images for distributions like *ubuntu* or *centos*

* **tested** images

     * [CentOS](https://cloud.centos.org/centos)
     * [Ubuntu](https://cloud-images.ubuntu.com)
     * [Debian](https://cdimage.debian.org/cdimage/openstack)

* **untested** images

     * [Devuan](https://files.devuan.org/devuan_ascii/virtual/)
     * Arch Linux

### defined pool

```
$ sudo mkdir /var/lib/libvirt/pool
$ virsh pool-define-as pool  --type dir --target /var/lib/libvirt/pool
$ virsh pool-autostart pool
$ virsh pool-start pool
```

### Download


#### centos

Take a look in the [repositoy](https://cloud.centos.org/centos/7/images/)

**1907**
```
$ sudo curl -sL https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1907.qcow2 --output /var/lib/libvirt/pool/CentOS-7-x86_64-GenericCloud-1907.qcow2
```

**latest 7 generic**
```
$ sudo curl -sL https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 --output /var/lib/libvirt/pool/CentOS-7-x86_64-GenericCloud-latest.qcow2
```


#### ubuntu

Take a look in the [repositoy](https://cloud-images.ubuntu.com/)

**1904 / disco**
```
$ sudo curl -s https://cloud-images.ubuntu.com/disco/current/disco-server-cloudimg-amd64.img --output /var/lib/libvirt/pool/ubuntu-1904-server-cloudimg-amd64.qcow2
```
**1910 / eoan**
```
$ sudo curl -sL https://cloud-images.ubuntu.com/eoan/current/eoan-server-cloudimg-amd64.img   --output /var/lib/libvirt/pool/ubuntu-1910-server-cloudimg-amd64.qcow2
```


#### debian

**9 / stretch**
```
$ sudo curl -s https://cdimage.debian.org/cdimage/openstack/current-9/debian-9-openstack-amd64.qcow2 --output /var/lib/libvirt/pool/debian-9-amd64.qcow2
```

**10 / buster**
```
$ sudo curl -s https://cdimage.debian.org/cdimage/openstack/current-10/debian-10-openstack-amd64.qcow2 --output /var/lib/libvirt/pool/debian-10-amd64.qcow2
```


```
$ # https://cdimage.debian.org/cdimage/openstack/current-10/
$ # https://files.devuan.org/devuan_ascii/virtual/devuan_ascii_2.0.0_amd64_qemu.qcow2.xz
```


## usage

```
$ terraform init
Initializing provider plugins…

Terraform has been successfully initialized!
You may now begin working with Terraform. Try running "terraform plan" to see any changes that are required for your infrastructure. All Terraform commands should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```
$ terraform plan


$ terraform apply [-auto-approve]


$ terraform show


$ terraform destroy [-auto-approve]


$ terraform destroy -target=libvirt_domain.${DOMAIN}
```

