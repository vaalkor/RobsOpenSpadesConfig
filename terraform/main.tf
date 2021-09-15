terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = ">= 3.58.0"
  }
}


provider "aws" {
    region = var.region
    shared_credentials_file = var.credentials_file
}

data "aws_vpc" "default" {
  default = true
} 

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20210813.1-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}

resource "aws_security_group" "spades_sec_group" {
  name        = "OpenSpadesSecurityGroup"
  description = "Allow ssh and the openspades default port."
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      description      = "Everything"
      security_groups  = null
      self             = null
      prefix_list_ids  = null

      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    },
    {
      description      = "Everything"
      security_groups  = null
      self             = null
      prefix_list_ids  = null

      description      = "Spades TCP"
      from_port        = 32887
      to_port          = 32887
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    },
    {
      description      = "Everything"
      security_groups  = null
      self             = null
      prefix_list_ids  = null

      description      = "Spades UDP"
      from_port        = 32887
      to_port          = 32887
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]

  egress = [
    {
      description      = "Everything"
      security_groups  = null
      self             = null
      prefix_list_ids  = null

      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
    }
  ]

  tags = {
    Name = "OpenSpadesSecurityGroup"
  }
}


resource "aws_instance" "spades_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
  security_groups = [aws_security_group.spades_sec_group.name]
  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "OpenSpadesServer"
  }
}
