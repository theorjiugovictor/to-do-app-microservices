[app_servers]
app-server ansible_host=${server_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${ssh_key_path}

[app_servers:vars]
domain=${domain}
acme_email=${acme_email}
jwt_secret=${jwt_secret}
github_repo=${github_repo}
