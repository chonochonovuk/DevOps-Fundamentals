terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

resource "docker_container" "con-web" {

  name = var.v_con_name

  image = var.v_image

  network_mode = var.v_network

  volumes {
  host_path = "/home/chono/Desktop/DevOps-Fundamentals/Homeworks/Homework1/Practice-with-docker-homework/container-web/site/"
  container_path = "/var/www/html/"
  }

  ports {

    internal = var.v_int_port

    external = var.v_ext_port

  }

}