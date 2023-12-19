variable "region" {
  description = "The AWS region"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "private_subnet_name" {
  description = "The name of the private subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
}

variable "public_subnet_name" {
  description = "The name of the public subnet"
  type        = string
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "ec2_instance_ami" {
  description = "The AMI for the EC2 instance"
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of the EC2 instance"
  type        = string
}

variable "igw_name" {
  description = "The name of the internet gateway"
  type        = string
}


variable "frontend_instance_name" {
  description = "The name of the Frontend EC2 instance"
  type        = string
}
variable "frontend_sg_name" {
  description = "The name of the Frontend security group"
  type = string
  
}
variable "backend_instance_name" {
  description = "The name of the backend EC2 instance"
  type        = string
}
variable "backend_sg_name" {
  description = "The name of the backend security group"
  type = string
  
}