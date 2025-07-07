## ----- Makefile ----- ##

# setting variables for color
GREEN := \e[0;32m
SUCCESS := \e[7;32m
RED = \e[0;31m
ERROR = \e[7;31m
YELLOW = \e[0;33m
WARNING = \e[7;33m
BLUE = \e[0;34m
INFO := \e[7;34m
BOLD = \e[1m
NC := \e[0m

# Directory containing the backend infra setup
BACKEND_DIR=backend

# File names
BACKEND_OUTPUT_JSON=backend_outputs.json
BACKEND_HCL=backend.hcl

# Python script path
GENERATOR_SCRIPT=scripts/generate_backend_hcl.py

# Main Terraform project directory (where backend.tf lives)
MAIN_DIR=.

# define target to bootstrap remote AWS s3 backend state management
.PHONY: setup_backend
setup_backend:
	@echo "$(BLUE)==> Initializing backend infrastructure...$(NC)"
	cd $(BACKEND_DIR) && terraform init
	cd $(BACKEND_DIR) && terraform apply -auto-approve

	@echo "$(BLUE)==> Capturing backend outputs to JSON...$(NC)"
	cd $(BACKEND_DIR) && terraform output -json > ../$(BACKEND_OUTPUT_JSON)

	@echo "$(BLUE)==> Generating backend.hcl...$(NC)"
	python3 $(GENERATOR_SCRIPT) $(BACKEND_OUTPUT_JSON) $(BACKEND_HCL)

	@echo "$(BLUE)==> Initializing Terraform with remote backend...$(NC)"
	cd $(MAIN_DIR) && terraform init -migrate-state -backend-config=$(BACKEND_HCL)

	@echo "$(SUCCESS)Backend setup complete.$(NC)"

# initialize terraform project
.PHONY: init
init:
	@echo "$(INFO)Initializing Terraform...$(NC)"
	@terraform init && echo "$(SUCCESS)Terraform initialization successful.$(NC)" || echo "$(ERROR)Terraform initialization failed.$(NC)"

# Run terrafom plan
.PHONY: plan
plan:
	@terraform plan

# format terraform code
.PHONY: fmt
fmt:
	@echo "$(INFO)Formatting Terraform files...$(NC)"
	@terraform fmt --recursive

# Validate Terraform code
.PHONY: validate
validate:
	@echo "$(INFO)Validating Terraform files...$(NC)"
	@terraform validate && echo "$(SUCCESS)File validation successful.$(NC)" || echo "$(ERROR)File validation failed.$(NC)"

# Apply terraform plan
.PHONY: apply
apply:
	@terraform apply

# Destroy resources described by Terraform
.PHONY: destroy
destroy:
	@terraform destroy

# print help message
.PHONY: help
help:
	@ echo "${BOLD}Help message coming soon...${NC}"