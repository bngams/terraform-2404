output "ip" {
  value = oci_core_instance.ubuntu_instance.public_ip
  description = "VM IP"
}