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


variable "instance_type" {
    type = string
    description = "The type of instance to create"
    default = "t3.medium"
}



resource "aws_instance" "web_server" {
  ami           = "ami-0b0b78dcacbab728f"
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
    Name = "MyWebServerChanged"
    Type = "WebServer"
  }
}

resource "aws_instance" "web_server2" {
  ami           = "ami-0b0b78dcacbab728f"
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