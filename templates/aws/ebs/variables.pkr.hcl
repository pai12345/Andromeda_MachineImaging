variable "instance_type" {
  default = ""
}
variable "region" {
  default   = ""
  sensitive = true
}
variable "base_name" {
  default = ""
}
variable "root_device_type" {
  default = ""
}
variable "virtualization_type" {
  default = ""
}
variable "most_recent" {
  default = false
}
variable "owners" {
  default   = [""]
  sensitive = true
}
variable "ssh_username" {
  default   = ""
  sensitive = true
}
variable "skip_create_ami" {
  default   = false
  sensitive = true
}
variable "max_retries" {
  default = 0
}