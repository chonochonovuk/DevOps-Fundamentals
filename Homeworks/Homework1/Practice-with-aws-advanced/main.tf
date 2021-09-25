provider "aws" {
    access_key = var.v-access-key
    secret_key = var.v-secret-key
    region = "eu-west-2"
}

resource "aws_vpc" "chono-vpc" {
  cidr_block = "10.10.0.0/16"

  enable_dns_hostnames = true

  enable_dns_support = true
  
  tags = {
    Name = "CHONO-VPC"
  }
}

resource "aws_internet_gateway" "chono-igw" {
  
  vpc_id = aws_vpc.chono-vpc.id

  tags = {
      Name = "CHONO-IGW"
  } 
}

resource "aws_route_table" "chono-prt" {
  vpc_id = aws_vpc.chono-vpc.id

  route {
      cidr_block = "0.0.0.0/0"

      gateway_id = aws_internet_gateway.chono-igw.id
  }

  tags = {
    Name = "CHONO-PUBLIC-RT"
  }
}

resource "aws_subnet" "chono-subnet" {
    
    count = var.v-count

    vpc_id = aws_vpc.chono-vpc.id

    cidr_block = var.chono-cidr[count.index]

    map_public_ip_on_launch = true

    availability_zone = data.aws_availability_zones.chono-avz.names[count.index]
  
    tags = {
      Name = "CHONO-SUB-NET-${count.index + 1}"
    }
}

resource "aws_route_table_association" "chono-prt-assoc" {

    count = var.v-count

    subnet_id = aws_subnet.chono-subnet.*.id[count.index]

    route_table_id = aws_route_table.chono-prt.id
  
}

resource "aws_security_group" "chono-pub-sg" {

    name = "chono-pub-sg"

    description = "CHONO Public SG"

    vpc_id = aws_vpc.chono-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "chono-server" {
  count = 2
  ami = var.v-ami-image
  instance_type = var.v-instance-type
  key_name = var.v-instance-key
  vpc_security_group_ids = [aws_security_group.chono-pub-sg.id]
  subnet_id = element(aws_subnet.chono-subnet.*.id,count.index)
  tags = {
      Name = "chono-server-${count.index + 1}"
  }

  provisioner "file" {
    source = "./provision.sh"
    destination = "/tmp/provision.sh"
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("/home/chono/aws-ec2/amazon-ec2-key.pem")
      host = self.public_ip
    }
  }

  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/provision.sh",
        "/tmp/provision.sh"
      ]
      connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("/home/chono/aws-ec2/amazon-ec2-key.pem")
      host = self.public_ip
    }
  }
}

