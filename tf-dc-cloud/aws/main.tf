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
  region  = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}


resource "aws_security_group" "public" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-example"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYrqC65QVnSPJo1mYs5nigrDlDP3ExNiZgl3Qxv084ZlC2ybFkRzzmJA/1axnS3XWvj4FNVlpHhzUHkUQ6MYxrDTmCAWde8zkpMT7P2jOGUtKzRgLXJcxPG9zvnM/ypQlM/kshlk6mEtBG4C8KBE8UHFQld3/b2g43O/wUa4cw4Gqm6Cr4VlzDL1jut3jHjdEXIverCRZMK8h6DYgZpZwBSOVDZX3suylSdXJ7Bqs0fBjFB4xPXPmyfzRGosPkfN+mVfuTm5wsI20wapZ2rX7n0Q5k/ZSDzDaZdN+Y92SQJbeJNB2qDVZPN5Mq6Ep7kiZ1ENW5YvlEz0GqUi/EIef2CwVcSMYVymiP0cGrXuAc6Hhiqh/mfNOHjpAe8oKVfbeN3fzr6rdWPIE0lmW5+m00VmOLg7ZvkG5Uaff3+3+Wz6NWm0IATzdB/xJJ4IINSYIfC07+pKeNeRx7iXFo2XEyxKdIIP2XikbadlMlHAGf5qDkjYJvQaDt52v4tasfIm8= bluszcz@slim"
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}


resource "aws_instance" "app_server" {
  ami           = "ami-08c40ec9ead489470"
  key_name= "aws_key"

  instance_type = "t2.micro"
#   network_interface {
#     network_interface_id = aws_network_interface.foo.id
#     device_index         = 0
#   }
associate_public_ip_address = true
   vpc_security_group_ids = [aws_security_group.public.id]

  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("/home/bluszcz/.ssh/id_rsa")
      timeout     = "4m"
   }


  tags = {
    Name = "vm-dev"
  }




} 
  
