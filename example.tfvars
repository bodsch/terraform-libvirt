
# Size in bytes (20 GB)
# size = 21474836480
# Size in bytes (10 GB)
# size = 10737418240
# Size in bytes (8 GB)
# size = 8589934592

servers = {
  "build" = {
    "memory"    = 16384
    "vcpu"      = 2
    "disk_size" = "64424509440"
    octetIP     = 10  # ip: "192.168.124.10"
    "hostname"  = "build"
  }
  "harbor" = {
    "memory"    = 2048
    "vcpu"      = 2
    "disk_size" = "21474836480"
    octetIP     = 11  # ip: "192.168.124.11"
    "hostname"  = "harbor"
  }
}
