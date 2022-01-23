locals {
  ami_name = "packer-ubuntu-aws-{{timestamp}}"
}
source "amazon-ebs" "ubuntu" {
  ami_name      = local.ami_name
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = var.base_name
      root-device-type    = var.root_device_type
      virtualization-type = var.virtualization_type
    }
    most_recent = var.most_recent
    owners      = var.owners
  }
  ssh_username = var.ssh_username
}
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}