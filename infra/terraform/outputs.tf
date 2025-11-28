output "server_public_ip" {
  description = "Public IP of the app server"
  value       = aws_instance.app_server.public_ip
}

output "server_id" {
  description = "Instance ID"
  value       = aws_instance.app_server.id
}

output "ssh_command" {
  description = "SSH command to connect to server"
  value       = "ssh -i ${var.ssh_private_key_path} ubuntu@${aws_instance.app_server.public_ip}"
}
