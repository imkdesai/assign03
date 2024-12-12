provider "aws" {
  region = "us-east-1"
}
 
# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
 
# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
 
# Public Subnet 1 (AZ1)
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Adjust AZ if needed
  map_public_ip_on_launch = true
}
 
# Public Subnet 2 (AZ2)
resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b" # Adjust AZ if needed
  map_public_ip_on_launch = true
}
 
# Security Group for Load Balancer
resource "aws_security_group" "lb" {
  vpc_id = aws_vpc.main.id
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
 
# Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id] # Include both subnets
}
 
# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}
 
# Public Route (Internet Gateway to Public Subnets)
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
 
# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}
 
resource "aws_route_table_association" "subnet_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}
 
