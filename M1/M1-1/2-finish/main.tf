provider "aws" {
  access_key = "<ACCESS-KEY>"
  secret_key = "<SECRET-KEY>"
  region     = "eu-central-1"
}

resource "aws_instance" "M1-1" {
  ami           = "ami-dd3c0f36"
  instance_type = "t2.micro"
  key_name      = "terraform-key"
}

output "public_ip" {
  value = aws_instance.M1-1.public_ip
}
output "public_dns" {
  value = aws_instance.M1-1.public_dns
}