job "mariadb-server" {
    datacenters = ["dc1"]
    type = "service"
    group "mariadb-server" {
      count = 1
      network {
      port "db" {
        to = 3306
        }
      }
      
      service {
      name = "mariadb-server"
      tags = ["global", "mariadb-server"]
      port = "db"
      }
      
        task "mariadb-server" {
            driver = "docker"
            config {
              image = "shekeriev/dob-w3-mysql:latest"
              ports = ["db"]
            }
            env {
              MYSQL_ROOT_PASSWORD = "12345"
            }
     
   }
 }
}
