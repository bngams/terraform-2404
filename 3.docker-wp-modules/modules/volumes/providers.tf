terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# inherited config from parent (if provider already exists in parent)
# provider "docker" {
#   # Configuration options
# }