terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

variable "SSH_PUBLIC_KEY" {
  type = string
}

variable "INSTANCE_TYPE" {
  type = string
}

data "aws_ami" "latest_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "minecraft_server_sg" {
  name = "MinecraftServerSG"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Java Minecraft Traffic"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow Traffic Out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "minecraft_server_key_pair" {
  key_name   = "minecraft_server_key_pair"
  public_key = file(var.SSH_PUBLIC_KEY)
}

resource "aws_instance" "minecraft_server" {
  ami                    = data.aws_ami.latest_ami.id
  instance_type          = var.INSTANCE_TYPE
  vpc_security_group_ids = [aws_security_group.minecraft_server_sg.id]
  key_name               = aws_key_pair.minecraft_server_key_pair.key_name

  tags = {
    Name = "MinecraftServer"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.minecraft_server.public_ip
}
