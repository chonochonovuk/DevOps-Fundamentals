provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "helm_release" "mariadb" {
  name = "mariadb"
  chart = "/home/chono/Desktop/DevOps-Fundamentals/M3/M3-3/1-helm/mariadb/"
}

resource "helm_release" "php_mysql" {
  name = "php-mysql"
  chart = "/home/chono/Desktop/DevOps-Fundamentals/M3/M3-3/1-helm/php-mysql/"
}