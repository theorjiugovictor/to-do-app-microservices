variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "hng-todo-app"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key"
  type        = string
}

variable "domain" {
  description = "Application domain"
  type        = string
}

variable "acme_email" {
  description = "Email for Let's Encrypt"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret"
  type        = string
  default     = "myfancysecret"
}

variable "github_repo" {
  description = "GitHub repository URL"
  type        = string
}