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

# -------------------------------------------------------------------
# Create the S3 Bucket for Terraform State
# -------------------------------------------------------------------

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terraform_state" {
  # Use a known bucket name here (after you run the code the first time)
  bucket = "${local.account_id}-terraform-states"

  # Enable versioning to keep track of state changes
  versioning {
    enabled = true
  }

  # Enable server-side encryption for security
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# -------------------------------------------------------------------
# Create the DynamoDB Table for State Locking
# -------------------------------------------------------------------

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# -------------------------------------------------------------------
# Create the EC2 Instance
# -------------------------------------------------------------------

resource "aws_instance" "web" {
  ami           = "ami-0866a3c8686eaeeba"  # Ensure this AMI ID is correct
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld1"
  }
}

# Note: Add backend configuration here after running the initial apply


