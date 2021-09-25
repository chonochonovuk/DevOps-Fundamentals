provider "aws" {
    access_key = "key is in aws-ec2 folder"
    secret_key = "secret_key is there"
    region = "eu-west-2"
}

resource "aws_instance" "chono-practice-1" {
  ami = "ami-0194c3e07668a7e36"
  instance_type = "t2.micro"
  key_name = "amazon-ec2-key"
  security_groups = [ "launch-wizard-1" ]
}

output "public_ip" {
  value = aws_instance.chono-practice-1.public_ip
}

output "public_dns" {
  value = aws_instance.chono-practice-1.public_dns
}
