terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami   = ami-0866a3c8686eaeebad
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}
