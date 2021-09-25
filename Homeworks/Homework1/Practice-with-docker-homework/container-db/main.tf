terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

resource "docker_container" "con-db" {

  name = var.v_con_name

  image = var.v_image

  network_mode = var.v_network

  env = [ "MYSQL_ROOT_PASSWORD=12345" ]

    ports {

    internal = var.v_int_port

    external = var.v_ext_port

  }

}