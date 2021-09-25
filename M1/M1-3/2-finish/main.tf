provider "aws" {
  access_key = var.v-access-key
  secret_key = var.v-secret-key
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
    count = var.v-count
    vpc_id = aws_vpc.dof-vpc.id
    cidr_block = var.dof-cidr[count.index]
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.dof-avz.names[count.index]
    tags = {
        Name = "DOF-SUB-NET"
    }
}

resource "aws_route_table_association" "dof-prt-assoc" {
    count = var.v-count
    subnet_id = aws_subnet.dof-snet.*.id[count.index]
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
    count = var.v-count
    ami = var.v-ami-image
    instance_type = var.v-instance-type
    key_name = var.v-instance-key
    vpc_security_group_ids = [aws_security_group.dof-pub-sg.id]
    subnet_id = element(aws_subnet.dof-snet.*.id, count.index)
    tags = {
        Name = "dof-server-${count.index + 1}"
    }
    provisioner "file" {
        source      = "./provision.sh"
        destination = "/tmp/provision.sh"
        connection {
            type = "ssh"
            user = "centos"
            private_key = file("terraform-key.pem")
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
            user = "centos"
            private_key = file("terraform-key.pem")
            host = self.public_ip
        }
    }
}
