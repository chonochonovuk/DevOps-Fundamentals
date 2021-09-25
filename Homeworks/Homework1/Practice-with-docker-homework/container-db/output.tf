output "container-id" {
  value = docker_container.con-db.id  
}

output "container-name" {
  value = docker_container.con-db.name
}