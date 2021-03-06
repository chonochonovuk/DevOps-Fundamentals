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

module "image" {
  source = "./image"
  v_image = lookup(var.v_image,var.mode)
}

module "container" {
  source = "./container"
  v_image = module.image.image_out
  v_con_name = lookup(var.v_con_name,var.mode)
  v_int_port = lookup(var.v_int_port,var.mode)
  v_ext_port = lookup(var.v_ext_port,var.mode)
}
