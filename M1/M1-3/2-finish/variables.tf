# Variables
# Some sensitive information
variable "v-access-key" {}
variable "v-secret-key" {}

# Shareable information
variable "v-ami-image" {
    description = "AMI image"
    default = "ami-dd3c0f36"
}
variable "v-instance-type" {
    description = "EC2 instance type"
    default = "t2.micro"
}
variable "v-instance-key" {
    description = "Instance key"
    default = "terraform-key"
}
variable "v-count" {
    description = "Resource count"
    default = "2"
}
data "aws_availability_zones" "dof-avz" {}
variable "dof-cidr" {
    type = list
    default = ["10.10.10.0/24", "10.10.11.0/24"] 
}
