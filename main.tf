provider "aws" {
  region = "ap-southeast-2"  # Update as necessary
}

resource "aws_instance" "c8" {
  ami           = "ami-0d6560f3176dc9ec0"  # Use the Amazon Linux AMI ID
  instance_type = "t2.micro"
  key_name      = "sheelam-hello"
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
  ami           = "ami-003f5a76758516d1e"  # Use the Ubuntu 21.04 AMI ID
  instance_type = "t2.micro"
  key_name      = "sheelam-hello"
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
