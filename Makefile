.PHONY: help init plan apply destroy deploy logs

help:
	@echo "Available commands:"
	@echo "  make init     - Initialize Terraform"
	@echo "  make plan     - Run Terraform plan"
	@echo "  make apply    - Apply Terraform changes"
	@echo "  make destroy  - Destroy infrastructure"
	@echo "  make deploy   - Deploy application locally"
	@echo "  make logs     - View application logs"

init:
	cd infra/terraform && terraform init

plan:
	cd infra/terraform && terraform plan

apply:
	cd infra/terraform && terraform apply -auto-approve

destroy:
	cd infra/terraform && terraform destroy

deploy:
	docker compose up -d --build

logs:
	docker compose logs -f

test:
	@echo "Testing application endpoints..."
	@curl -f https://$(DOMAIN) || echo "Frontend: FAILED"
	@curl -f https://$(DOMAIN)/api/auth || echo "Auth API: FAILED"
	@curl -f https://$(DOMAIN)/api/todos || echo "Todos API: FAILED"
	@curl -f https://$(DOMAIN)/api/users || echo "Users API: FAILED"