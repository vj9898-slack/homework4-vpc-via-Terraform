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

resource "aws_subnet" "hw4-subnet1-public" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.0/26"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet1-public"
    }
}

resource "aws_subnet" "hw4-subnet2-public" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.64/26"
    map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet2-public"
    }
}

resource "aws_subnet" "hw4-subnet1-private" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.128/26"
    map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet1-private"
    }
}

resource "aws_subnet" "hw4-subnet2-private" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.192/26"
    map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet2-private"
    }
}
