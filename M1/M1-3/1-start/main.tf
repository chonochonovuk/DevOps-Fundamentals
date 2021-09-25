provider "aws" {
  access_key = "<ACCESS-KEY>"
  secret_key = "<SECRET-KEY>"
  region     = "eu-central-1"
}

resource "aws_vpc" "dof-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
      Name = "DOF-VPC"
  }
}

resource "aws_internet_gateway" "dof-igw" {
    vpc_id = aws_vpc.dof-vpc.id 
    tags = {
        Name = "DOF-IGW"
    }
}

resource "aws_route_table" "dof-prt" {
    vpc_id = aws_vpc.dof-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dof-igw.id
    }
    tags = {
        Name = "DOF-PUBLIC_RT"
    }
}

resource "aws_subnet" "dof-snet" {
    vpc_id = aws_vpc.dof-vpc.id
    cidr_block = "10.10.10.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "DOF-SUB-NET"
    }
}

resource "aws_route_table_association" "dof-prt-assoc" {
    subnet_id = aws_subnet.dof-snet.id
    route_table_id = aws_route_table.dof-prt.id
}

resource "aws_security_group" "dof-pub-sg" {
    name = "dof-pub-sg"
    description = "DOF Public SG"
    vpc_id = aws_vpc.dof-vpc.id
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

resource "aws_instance" "dof-server" {
    ami = "ami-dd3c0f36"
    instance_type = "t2.micro"
    key_name = "terraform-key"
    vpc_security_group_ids = [aws_security_group.dof-pub-sg.id]
    subnet_id = aws_subnet.dof-snet.id
}

output "public_ip" {
  value = aws_instance.dof-server.public_ip
}
