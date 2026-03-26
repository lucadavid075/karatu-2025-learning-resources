terraform {
  required_version = ">= 1.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.37.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  ami_id = "ami-0b0b78dcacbab728f"
}


variable "instance_type" {
  type        = string
  description = "The type of instance to create"
  default     = "t3.micro"
}

variable "ssh_private_key" {
  type = string
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  # key_name      = var.ssh_private_key

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "MyWebServerChanged"
    Type = "WebServer"
  }
}

resource "aws_instance" "web_server2" {
  ami           = local.ami_id
  instance_type = var.instance_type

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "MyWebServer2"
    Type = "WebServer"
  }
}


output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "web_server2_public_ip" {
  value = aws_instance.web_server2.public_ip
}

output "web_servers" {
  value = [aws_instance.web_server.public_ip, aws_instance.web_server2.public_ip]
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}






# cli-variable -> tfvars-file -> environement-variable -> tfvars-default -> default-value -> prompt-for-input

# cli-variable: terraform plan -var="instance_type=t3.micro"
# tfvars-file: terraform plan"
# custom tfvars file: terraform plan -var-file="custom.tfvars"
# environment variable: export TF_VAR_instance_type=t3.micro
