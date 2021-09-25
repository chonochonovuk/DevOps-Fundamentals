job "php" {
  datacenters = ["dc1"]
  type = "service"
  group "php" {
    count = 1
    network {
      port "web" {
        static = 80
        to = 80
        host_network = "public"
        }
      }
      
    volume "site_st" {
      type      = "host"
      read_only = false
      source    = "site"
    }
    
    service {
      name = "php"
      tags = ["global", "php"]
      port = "web"
      }
      
     task "php" {
       driver = "docker"
       
      volume_mount {
        volume      = "site_st"
        destination = "/var/www/html"
        read_only   = false
       }
    
       config {
       image = "shekeriev/dob-w3-php:latest"
       ports = ["web"]
      }
    }
  }
}
