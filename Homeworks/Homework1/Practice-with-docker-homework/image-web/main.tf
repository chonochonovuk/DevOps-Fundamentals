terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.14.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}



resource "docker_image" "img-web" {
  name = var.v_image
  
}