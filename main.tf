terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  access_key = “COPY_YOUR_ACCESS_KEY“
  secret_key = "COPY_YOUR_SECRET_KEY"
  token = “COPY_YOUR_TOKEN_HERE”
  region  = "us-east-1"
}

resource "aws_vpc" "hw4_vpc"{

    cidr_block = "10.0.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
        Name = "hw4_vpc"
    }

}

resource "aws_internet_gateway" "hw4_igw"{
    vpc_id = aws_vpc.hw4_vpc.id

    tags = {
        Name = "hw4_igw"
    }
}
