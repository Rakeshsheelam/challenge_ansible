provider "aws" {
  region = "us-east-1"  # Update as necessary
}

resource "aws_instance" "c8" {
  ami           = "ami-xxxxxxxx"  # Use the Amazon Linux AMI ID
  instance_type = "t2.micro"
  key_name      = "your-ssh-key"
  tags = {
    Name = "c8.local"
  }

  # Assign hostname
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname c8.local
              EOF
}

resource "aws_instance" "u21" {
  ami           = "ami-xxxxxxxx"  # Use the Ubuntu 21.04 AMI ID
  instance_type = "t2.micro"
  key_name      = "your-ssh-key"
  tags = {
    Name = "u21.local"
  }

  # Assign hostname
  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname u21.local
              EOF
}

# Output instance details for Ansible dynamic inventory
output "frontend" {
  value = aws_instance.c8.public_ip
}

output "backend" {
  value = aws_instance.u21.public_ip
}
