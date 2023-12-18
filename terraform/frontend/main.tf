provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "remix-frontend" {
  ami           = "ami-0cbd40f694b804622"
  instance_type = "t2.micro"
  key_name = "admin"
  vpc_security_group_ids = [aws_security_group.remix_frontend_sg.id]
  tags = {
    Name = "tf-ansible-demo"
  }
}


resource "aws_security_group" "remix_frontend_sg" {
  name        = "remix_frontend_sg"
  description = "Security Group for remix-frontend EC2 instance"

  ingress {
    description = "all tcp"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["71.193.17.47/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
