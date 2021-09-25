# Shareable information

variable "v-ami-image" {

    description = "AMI image"

    default = "ami-0194c3e07668a7e36"

}

variable "v-instance-type" {

    description = "EC2 instance type"

    default = "t2.micro"

}

variable "v-instance-key" {

    description = "Instance key"

    default = "amazon-ec2-key"

}

variable "v-count" {

    description = "Resource count"

    default = "2"

}

data "aws_availability_zones" "chono-avz" {}

variable "chono-cidr" {

  type = list
  default = ["10.10.10.0/24","10.10.11.0/24"]

}

# Some sensitive information

variable "v-access-key" {}

variable "v-secret-key" {}
