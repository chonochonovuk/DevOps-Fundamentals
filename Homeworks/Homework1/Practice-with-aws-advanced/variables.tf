# Shareable information

variable "v-ami-image" {

    description = "AMI image"

}

variable "v-instance-type" {

    description = "EC2 instance type"

}

variable "v-instance-key" {

    description = "Instance key"

}

variable "v-count" {

    description = "Resource count"

}

data "aws_availability_zones" "chono-avz" {}

variable "chono-cidr" {

  type = list

}

# Some sensitive information

variable "v-access-key" {}

variable "v-secret-key" {}
