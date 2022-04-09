variable "misp_cicd_vars" {}
variable "homelab_vars" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.8"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  region = lookup(var.misp_cicd_vars, "region")
}

resource "aws_security_group" "cudeso_misp_cicd_securitygroup" {
  name        = lookup(var.misp_cicd_vars, "secgroupname")
  description = lookup(var.misp_cicd_vars, "secgroupname")
  vpc_id      = lookup(var.misp_cicd_vars, "vpc")

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = lookup(var.homelab_vars, "cidr_blocks")
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = lookup(var.homelab_vars, "cidr_blocks")
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "cudeso_misp_cicd_instance" {
  ami                         = lookup(var.misp_cicd_vars, "ami")
  instance_type               = lookup(var.misp_cicd_vars, "instance_type")
  subnet_id                   = lookup(var.misp_cicd_vars, "subnet")
  associate_public_ip_address = lookup(var.misp_cicd_vars, "public_ip")


  vpc_security_group_ids = [
    aws_security_group.cudeso_misp_cicd_securitygroup.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
  }
  tags = {
    Name    = "MISP"
    Managed = "IAC"
  }

  depends_on = [aws_security_group.cudeso_misp_cicd_securitygroup]
}


output "ec2instance" {
  value = aws_instance.cudeso_misp_cicd_instance.public_ip
}