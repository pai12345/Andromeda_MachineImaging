locals {
  timestamp = timestamp()
  ami_name  = "packer-ubuntu-aws-{{timestamp}}"
  cloud     = "aws"
}
source "amazon-ebs" "ubuntu" {
  ami_name                = local.ami_name
  ami_description         = "aws ebs backed ami"
  ami_virtualization_type = "hvm"
  instance_type           = var.instance_type
  region                  = var.region
  skip_create_ami         = var.skip_create_ami
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
  max_retries  = var.max_retries
  run_volume_tags = {
    type   = "volume"
    cloud  = local.cloud
    volume = var.root_device_type
  }
  tags = {
    type                    = "ami"
    cloud                   = local.cloud
    ami_virtualization_type = "hvm"
  }
  snapshot_tags = {
    type                    = "snapshot"
    cloud                   = local.cloud
    ami_virtualization_type = "hvm"
  }
}
build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "file" {
    only        = ["source.amazon-ebs.ubuntu"]
    source      = "../../../scripts/update.sh"
    destination = "/tmp/update.sh"
    max_retries = var.max_retries
  }
  provisioner "shell" {
    only        = ["source.amazon-ebs.ubuntu"]
    inline      = ["sh /tmp/update.sh"]
    max_retries = var.max_retries
  }
  post-processor "checksum" {
    checksum_types = ["sha256"]
    output         = "${local.ami_name}.checksum"
  }
  post-processor "manifest" {
    output = "manifest.json"
    custom_data = {
      timestamp = "${local.timestamp}"
    }
  }
}