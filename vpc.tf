data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.2019*-x86_64-gp2"]
  }
}

# Define our VPC
resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "isolated-private-subnet-vpc"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Isolated Private Subnet"
  }
}

# Define the security group
resource "aws_security_group" "sgweb" {
  name        = "isolated-private-subnet-sg"
  description = "Allow all tcp/udp/icmp traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "isolated-private-subnet-web-server-sg"
  }
}

