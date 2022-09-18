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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQCfRZxerwdxC/M5pTt0d2wJJXych1ovdJCsB8KUac2pipSr/NHBLFvPMSWmlQe3EFy7iw9BzMSZiWDR1I4s00pCV1sjm0U/UczRv+/ULHAZ7Bx5bGo48hvRCAb4q78EEf8eRwCb797lW2QRmF+AbMmQcfDVXRcmJzWzmq6Zq5GHSGGQNPfmQ8apssAL8mR9zNb75s3dhYGmtITxLoWeIBrF5CDtKiH4njMFrkoUUelr0nZWG2SW28qhUIHYloYbkAgcM35Zr7qM4uh8uNVGTiVZinZYeMz0Hzw090MAeCuxYvwSM5EuAEkkotK9rw/SUNlUB/HqROeQCzDvwotJ2k8k96f5xJ8CMezDNbKsLfOO0tDtnq7L/9l6VMMq9Sc/0k3kpPtnEev5QTMgY6tlZs7+R1ES4ZPm+CdWnwtOpoI37CqRvFukJXAxK2C7VE93w5tkewtnR74IhGCXY4WqrdM2LZ6tjFcbU78605Ty33yf04XF3CiRZ0/7bEGQRkSVba2FV2vyaJllKLG0tNVRuuGbUNP/ciG3ob4VQljAHcZ0xCk/xdZd3QaB60J9cR/Ze3w+Nr2AOkZ0phv+Dde0FK3q7Lo5KG4tWs/dMmsj1vypxBZw+iWx2BqHG2pbdNnWZBwgnjFdQvxx1AO1aH8nIgI4dHxOgJdZ3sbDJlrdRycmXnzM7g81WBJgBdlqPoOxtdEnEXj9NkmOjTCtqOI6m9hC+kpUG9wF5WyPUpG76/l5jwfVVwdv1RS24XY/PMWdm0wd0WGDg95Gd2wTd+5mwfYFLyr0/6PFU8zbiEbu0U8osw6XnztzzhC0/4+cw0BVuXS6MVtpg3xOPBRI25AMGOmicGF4fKkuIYR/g+Yk0ScT5YZ45ylUQgiKSAhFoR3lPhZu82/ykLtSQj0R1u6/2MhXoiwC1qjZhGf7oRFxEMtpbPqPy12zMXtx/IlxuKGIHmDDZtFzAbpgpDMHzAnlKjUJadOmR+Q38ifOKs5RvYuDL0AA0oAswl/VbyoSUNqpAU2D7JJUtbqjLylx4v/InDl/3IzS4palz+sC2Una4U07+mT4zyFC0R1flMOsKyQl/9VS4j1Hk2+fjS0QSLFqb+2AO2KXtYs8ZdeM3Wan7H58fziYgayZSK+J6TuSKdtYo54/sDYmmNz49lwglv7CxW0xHg2XHJxkXeXyfcNE1zhlamPRmjKQT1tq1cMrZK45fQn+9CUd7jYfqKbGuIT+BN2Z4ZcU0ZllIGQRdLfKhPyxRMfT9aUHn5P9FmM0M48rFfRewEZ523eiK72u2j/qHN8uoCJvwPPETLLGW6qp21ZH0Cnh4QTNcMhtEFRzpYgjSwEVSzYVZbCDJDVTMSwdD6sx rzawadzki@sqlipc"
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
  
