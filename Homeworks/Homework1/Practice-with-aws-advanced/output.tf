output "public_ip" {
    value = aws_instance.chono-server.*.public_ip
}
