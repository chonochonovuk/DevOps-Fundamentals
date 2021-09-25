# Configure the provider. This can be omitted if matches the configuration made with "aws configure"
provider "aws" {
  access_key = "<ACCESS-KEY>"
  secret_key = "<SECRET-KEY>"
  region     = "eu-central-1"
}

# Collect and store data about the default VPC
data "aws_vpc" "default" {
  default = true
}
# Collect and store data about the subnets in the default VPC
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
} 
# Get the latest AMI with Amazon Linux
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
 }
}
