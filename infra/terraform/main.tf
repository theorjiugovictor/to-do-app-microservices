terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket = "hng-terraform-state-prince"
    key    = "hng-todo-app/terraform.tfstate"
    region = "eu-west-1"
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "app_server" {
  name        = "${var.project_name}-server-sg"
  description = "Security group for TODO app server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-server-sg"
  }
}

# EC2 Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.ssh_public_key_path)
}

# EC2 Instance
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app_server.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname ${var.project_name}-server
              EOF

  tags = {
    Name = "${var.project_name}-server"
  }

  lifecycle {
    ignore_changes = [ami]
  }
}

# Generate Ansible Inventory
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tpl", {
    server_ip         = aws_instance.app_server.public_ip
    ssh_key_path      = var.ssh_private_key_path
    domain            = var.domain
    acme_email        = var.acme_email
    jwt_secret        = var.jwt_secret
    github_repo       = var.github_repo
  })
  filename = "${path.module}/../ansible/inventory.ini"

  depends_on = [aws_instance.app_server]
}

# Trigger Ansible
resource "null_resource" "run_ansible" {
  depends_on = [local_file.ansible_inventory]

  triggers = {
    instance_id = aws_instance.app_server.id
    always_run  = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for instance to be ready..."
      sleep 60
      cd ${path.module}/../ansible
      ansible-playbook -i inventory.ini playbook.yml
    EOT
  }
}

# Data Sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
