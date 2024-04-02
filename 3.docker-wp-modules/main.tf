resource "docker_network" "wordpress_network" {
  name = "wordpress_network"
}

module "volumes" {
  source = "./modules/volumes"
  volumes_names = var.volumes_names
}

resource "docker_image" "mariadb" {
  name         = "mariadb:10.6.4-focal"
  keep_locally = false # delete image on destroy 
}

resource "docker_image" "wordpress" {
  name         = "wordpress:latest"
  keep_locally = false # delete image on destroy 
}

resource "docker_container" "db" {
  image = docker_image.mariadb.image_id
  name  = "db"
  hostname = "db"
  volumes {
    # volume_name    = docker_volume.db_data.name
    volume_name = module.volumes.custom_volumes["db_data"].name
    container_path = "/var/lib/mysql"
  }
  restart = "always"
  env = [
    "MYSQL_ROOT_PASSWORD=somewordpress",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=wordpress",
  ]
  networks_advanced {
    name = docker_network.wordpress_network.name
  }
  #   ports {
  #     internal = 3306
  #     //
  #   }
  #   ports {
  #     internal = 2048
  #     //
  #   }
}

resource "docker_container" "wordpress" {
  image = docker_image.wordpress.image_id
  name  = "wordpress"
  ports {
    internal = 80
    external = 8888
  }
  restart = "always"
  env = [
    "WORDPRESS_DB_HOST=db:3306",
    "WORDPRESS_DB_USER=wordpress",
    "WORDPRESS_DB_PASSWORD=wordpress",
    "WORDPRESS_DB_NAME=wordpress",
  ]
  networks_advanced {
    name = docker_network.wordpress_network.name
  }
  volumes {
    # volume_name    = docker_volume.wp_data.name
    volume_name = module.volumes.custom_volumes["wp_data"].name
    container_path = "/var/www"
  }
  depends_on = [
    docker_container.db,
  ]
}