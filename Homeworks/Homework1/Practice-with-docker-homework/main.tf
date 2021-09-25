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

module "image-web" {
  source = "./image-web"
  v_image = lookup(var.v_image,"web")
}

module "image-db" {
  source = "./image-db"
  v_image = lookup(var.v_image,"db")
}
module "container-web" {
  source = "./container-web"
  v_image = module.image-web.image_out
  v_con_name = lookup(var.v_con_name,"web")
  v_int_port = lookup(var.v_int_port,"web")
  v_ext_port = lookup(var.v_ext_port,"web")
  v_network = var.v_network
}

module "container-db" {
  source = "./container-db"
  v_image = module.image-db.image_out
  v_con_name = lookup(var.v_con_name,"db")
  v_int_port = lookup(var.v_int_port,"db")
  v_ext_port = lookup(var.v_ext_port,"db")
  v_network = var.v_network
}

resource "docker_network" "dob-network" {
  name = var.v_network
}