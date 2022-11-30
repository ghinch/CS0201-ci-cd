provider "aws" {
  region   = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web_server_sg" {
  name = "web_server_sg"
  vpc_id = data.aws_vpc.default.id

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "webserver" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.web_server_sg.id
  ]

  associate_public_ip_address = true
}

output "server_ip" {
  value = aws_instance.webserver.public_ip
}

output "server_resource_id" {
  value = aws_instance.webserver.id
}
