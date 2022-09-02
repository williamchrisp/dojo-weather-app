# ENV Variables requires for multiple commands
export ECR_NAME=$$($(MAKE) get_ecr_name)
export AWS_REGION=$$($(MAKE) get_aws_region)

# Compose and Docker Commands
COMPOSE_RUN_TERRAFORM = docker-compose run --rm tf
COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose run --rm --entrypoint aws tf
COMPOSE_RUN_APP = docker-compose run --rm -p "8080:3000" app
COMPOSE_BUILD_APP = docker-compose build app
DOCKER_CLEAN = docker-compose down --remove-orphans && docker image prune -a

# Terraform Pipeline and Local Commands
.PHONY: run_plan run_apply run_destroy_plan run_destroy_apply
run_plan: init plan

run_apply: init apply

run_destroy_plan: init destroy_plan

run_destroy_apply: init destroy_apply

# Individual Terraform Commands
.PHONY: version init plan apply destroy_plan destroy_apply
version:
	$(COMPOSE_RUN_TERRAFORM) --version
	 
init:
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false

apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy

destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve

# Docker Pipeline and Local Commands
.PHONY: run_app push_app
run_app: build run

push_app: build tag aws_login push

# Individual Docker Commands
.PHONY: build tag push run clean
build:
	$(COMPOSE_BUILD_APP)

tag:
	docker tag weather-app:1 $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_NAME):1

push:
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_NAME):1

run:
	$(COMPOSE_RUN_APP)

clean:
	$(DOCKER_CLEAN)

# AWS and Variable Commands
.PHONY: aws_login get_ecr_name get_aws_region get_aws_account_id
aws_login:
	$(COMPOSE_RUN_AWS) ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

get_ecr_name:
	@$(COMPOSE_RUN_TERRAFORM) output -raw ecr_name

get_aws_region:
	@$(COMPOSE_RUN_TERRAFORM) output -raw region_name 
