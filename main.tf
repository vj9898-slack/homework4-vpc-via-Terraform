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
  access_key = "ASIAY2QMXMEZ7S7ENUEH"
  secret_key = "MjkiivxCj9J6MBx2ujUzyUAieQD7pn6w5DEaJsF0"
  token = "FwoGZXIvYXdzEJT//////////wEaDGZSXrfbnfN4mmX9MiK8ATuckzhtek7+W/LaDDYmvJmOmsnR4RBVgYcUJpGQrhQEuVbPpu9Gh8fvCrWqNz2r9seSui00wusRXhoRi6e0F57RtzRVCEc8AuJsV4OKaPZtlx40L/V5enmDNsE+tL599peTLEBexwrZGwtYKRoFsFlNbgJXPgyOThiMKNx1/mV8P+RVjM/AVVmtAh9ASY5x1Kt6WkSJGCt6h9qmVDfucQ5gKM/MxW3BDCVaISp7It+4w7N9RObtzKnvNx0LKPr/05kGMi1KpkcBFqJofowmj2Ifxgbbp46D62Pf7apA3mjmDl5DasyM5zX9gtuBhiwrWII="
  region  = "us-east-1"
}

// VPC
resource "aws_vpc" "hw4_vpc"{

    cidr_block = "10.0.0.0/24"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
        Name = "hw4_vpc"
    }

}

// Internet Gateway
resource "aws_internet_gateway" "hw4_igw"{
    vpc_id = aws_vpc.hw4_vpc.id

    tags = {
        Name = "hw4_igw"
    }
}

// Public Subnet 1
resource "aws_subnet" "hw4-subnet1-public" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.0/26"
    map_public_ip_on_launch = "false"
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet1-public"
    }
}

// Public Subnet 2
resource "aws_subnet" "hw4-subnet2-public" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.64/26"
    map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet2-public"
    }
}

// Private Subnet 1
resource "aws_subnet" "hw4-subnet1-private" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.128/26"
    map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet1-private"
    }
}

// Private Subnet 2
resource "aws_subnet" "hw4-subnet2-private" {
    vpc_id = aws_vpc.hw4_vpc.id
    cidr_block = "10.0.0.192/26"
    map_public_ip_on_launch = "false" 
    availability_zone = "us-east-1a"
    tags = {
        Name = "hw4-subnet2-private"
    }
}

// Public Route Table
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

// Private Route Table
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

// Public Route Table Association
resource "aws_route_table_association" "hw4-public-association-1" {
    subnet_id = aws_subnet.hw4-subnet1-public.id
    route_table_id =  aws_route_table.hw4-public-route-table.id
}

// Public Route Table Association
resource "aws_route_table_association" "hw4-public-association-2" {
    subnet_id = aws_subnet.hw4-subnet2-public.id
    route_table_id = aws_route_table.hw4-public-route-table.id
}

// Private Route Table Association
resource "aws_route_table_association" "hw4-private-association-1" {
    subnet_id = aws_subnet.hw4-subnet1-private.id
    route_table_id = aws_route_table.hw4-private-route-table.id
}

// Private Route Table Association
resource "aws_route_table_association" "hw4-private-association-2" {
    subnet_id = aws_subnet.hw4-subnet2-private.id
    route_table_id = aws_route_table.hw4-private-route-table.id
}

// NAT Gateway
resource "aws_nat_gateway" "hw4-nat-gateway" {
    allocation_id = aws_eip.hw4-elastic-ip.id
    subnet_id     = aws_subnet.hw4-subnet1-public.id

    tags = {
        Name = "hw4-nat-gateway"
    }   

    // To ensure proper ordering
    depends_on = [aws_internet_gateway.hw4_igw]
}

// Elastic IP
resource "aws_eip" "hw4-elastic-ip" {
    instance = aws_instance.hw4-ec2-instance.id
    vpc      = true

    depends_on = [aws_internet_gateway.hw4_igw]
}

// EC2 Instance
resource "aws_instance" "hw4-ec2-instance" {

    // Amazon Linux 2 Kernel 5.10 AMI 2.0.20220912.1 x86_64 HVM gp2
    ami           = "ami-026b57f3c383c2eec" 
    instance_type = "t2.micro"

    tags = {
        Name = "hw4-ec2-instance"
    }

    // To ensure proper ordering
    depends_on = [aws_internet_gateway.hw4_igw]
}

// Security Group
resource "aws_security_group" "hw4-security-group" {
    name        = "hw4-security-group"
    description = "Allow TLS inbound traffic"
    vpc_id      = aws_vpc.hw4_vpc.id

    ingress {
        description      = "Enable SSH access via port 22"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = [aws_vpc.hw4_vpc.cidr_block]
    }

    tags = {
        Name = "hw4-security-group"
    }
}