
provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "demovpc" {
    cidr_block = var.cidr

    tags = {
      name ="demovpc"
    }
}
resource "aws_subnet" "sub1" {
    vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
    }
    resource "aws_internet_gateway" "igw1" {
      vpc_id = aws_vpc.demovpc.id
    }
    resource "aws_route_table" "rt1" {
      vpc_id = aws_vpc.demovpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw1.id
    }
    }
    resource "aws_route_table_association" "rt1" {
        subnet_id = aws_subnet.sub1.id
        route_table_id = aws_route_table.rt1.id
      
 }
 resource "aws_security_group" "demo_sg" {
   name = "demo_sg"
    vpc_id = aws_vpc.demovpc.id
 
  
   ingress {
     description = "SSH"
    from_port =22
    to_port=22
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
 }

  ingress{
    description="HTTP"
    from_port=80
    to_port=80
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
 }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo_sg"
  }
 }
 resource "aws_instance" "demo" {
    ami = var.ami_value
    instance_type = var.instance_type_value
    vpc_security_group_ids = [aws_security_group.demo_sg.id]
    subnet_id = aws_subnet.sub1.id

    tags = {
      Name = "demo"
    }
 }
 
 



