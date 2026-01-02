
provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}

resource "aws_instance" "do" {
    ami           = "ami-0ecb62995f68bb549"  # Specify an appropriate AMI ID
    instance_type = "t2.micro"
}