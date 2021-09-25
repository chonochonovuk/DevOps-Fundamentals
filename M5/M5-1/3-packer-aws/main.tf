provider "aws" {
  access_key = "<YOUR-ACCESS-KEY>"
  secret_key = "<YOUR-SECRET-KEY>"
  region     = "eu-central-1"
}

resource "aws_instance" "M5-1-3" {
  ami           = "<YOUR-AMI>"
  instance_type = "t2.micro"
  key_name      = "<YOUR-KEY>"
}

output "Public-IP" {
  value = aws_instance.M5-1-3.public_ip
}

output "Public-DNS" {
  value = aws_instance.M5-1-3.public_dns
}
