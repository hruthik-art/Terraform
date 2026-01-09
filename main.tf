provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}
resource "aws_vpc" "vpc1" {
    cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "subnet1" {
    vpc_id            = aws_vpc.vpc1.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "igw1" {
    vpc_id = aws_vpc.vpc1.id
}
resource "aws_route_table" "rt1" {
    vpc_id = aws_vpc.vpc1.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw1.id
    }
}
resource "aws_route_table_association" "rta1" {
    subnet_id      = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt1.id
}
resource "aws_instance" "linux_instance" {
    ami           = "ami-0ecb62995f68bb549"  # Specify an appropriate AMI ID
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.subnet1.id
}
