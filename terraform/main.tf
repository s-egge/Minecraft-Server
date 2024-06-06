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
  region = var.instance_region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "minecraft" {
  name        = "minecraft_security_group"
  description = "Security group to allow traffic for Minecraft"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH allowed"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS ingress"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "minecraft_server_key" {
  key_name   = "minecraft_server_key"
  public_key = file("./minecraft_server_key.pub")
}

resource "aws_eip" "minecraft_eip" {
  vpc = true
}

resource "aws_eip_association" "minecraft_eip_assoc" {
  instance_id   = aws_instance.minecraft_server.id
  allocation_id = aws_eip.minecraft_eip.id
}

resource "aws_instance" "minecraft_server" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.minecraft_server_key.key_name
  vpc_security_group_ids      = [aws_security_group.minecraft.id]
  associate_public_ip_address = true

  depends_on = [aws_security_group.minecraft]

  tags = {
    Name = var.instance_name
  }
}
