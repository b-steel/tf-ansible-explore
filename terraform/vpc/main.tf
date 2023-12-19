# provider block 
provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr
  
  tags = {
    Name = var.vpc_name
  }
}

# PRIVATE SUBNET
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = var.private_subnet_name
  }
}

# PUBLIC SUBNET
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = var.public_subnet_name
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "test_gw" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = var.igw_name
  }
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gw.id
  }
  tags = {
    Name = "public_rt"
  }
}

# ASSOCIATE PUBLIC RT
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# EIP FOR ANT GATEWAY
resource "aws_eip" "public_subnet" {
  domain   = "vpc"
  depends_on = [ aws_internet_gateway.test_gw ]
}

# NAT GATEWAY
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.public_subnet.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "nat_gateway"
  }
  depends_on = [ aws_internet_gateway.test_gw ]
}


# PRIVATE ROUTE TABLE
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "private_rt"
  }
}

# ASSOCIATE PUBLIC RT
resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}



# FRONTEND SG
resource "aws_security_group" "remix_frontend_sg" {
  description = "Security Group for remix-frontend EC2 instance"
  vpc_id = aws_vpc.test_vpc.id
  
  ingress {
    description = "http"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.frontend_sg_name
  }
}

# FRONTENT EC2
resource "aws_instance" "remix-frontend" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.remix_frontend_sg.id]
  key_name = "admin"
  associate_public_ip_address = true
  

  tags = {
    Name = var.frontend_instance_name
  }
}



# BACKEND SG
resource "aws_security_group" "backend_sg" {
  description = "Security Group for backend EC2 instance"
  vpc_id = aws_vpc.test_vpc.id
  
  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.backend_sg_name
  }
}

# BACKEND EC2
resource "aws_instance" "backend_instance" {
  ami           = var.ec2_instance_ami
  instance_type = var.ec2_instance_type
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name = "admin"

  tags = {
    Name = var.backend_instance_name
  }
}

