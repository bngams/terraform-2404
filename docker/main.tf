# Start a container
resource "docker_container" "ubuntu" {
  name  = "foo"
  image = docker_image.ubuntu.image_id
  command = ["sleep", "infinity"] 
  env = ["KEY=VALUE"] 
  # dependency is implicit, but we can sepecify it 
  depends_on = [
    docker_image.ubuntu
  ]
}

# Find the latest Ubuntu precise image.
resource "docker_image" "ubuntu" {
  name = "ubuntu:precise"
}