provider "aws" {
  region = "ap-south-1"
}

# Specify the EC2 details
resource "aws_instance" "example" {
  ami           = var.amiid
  instance_type = "t2.micro"
}
