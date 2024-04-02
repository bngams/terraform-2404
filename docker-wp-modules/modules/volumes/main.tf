resource "docker_volume" "volumes" {
  for_each = toset(var.volumes_names)
  name = each.key
}
