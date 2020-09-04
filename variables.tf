
variable "servers" {
  type = map(map(string))
  default = {
    "build" = {
      memory    = 512
      vcpu      = 1
      disk_size = "8589934592"
      octetIP     = 10
      hostname  = "build"
    }
    "harbor" = {
      memory    = 512
      vcpu      = 1
      disk_size = "8589934592"
      octetIP   = 11
      hostname  = "harbor"
    }
  }
}
