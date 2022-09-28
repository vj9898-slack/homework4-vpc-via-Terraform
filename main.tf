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

resource "aws_route_table" "hw4-public-route-table" {
    vpc_id = aws_vpc.hw4_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.hw4_igw.id
    }

    tags = {
        Name = "hw4-public-route-table"
    }
}

resource "aws_route_table" "hw4-private-route-table" {
    vpc_id = aws_vpc.hw4_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.hw4_igw.id
    }

    tags = {
        Name = "hw4-private-route-table"
    }
}

resource "aws_route_table_association" "hw4-public-association" {
    subnet_id: aws_subnet.hw4-subnet1-public.id
    route_table_id: aws_route_table.hw4-public-route-table.id
}

resource "aws_route_table_association" "hw4-private-association" {
    subnet_id: aws_subnet.hw4-subnet1-private.id
    route_table_id: aws_route_table.hw4-private-route-table.id
}