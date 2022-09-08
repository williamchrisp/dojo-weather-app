# Compose and Docker Commands
COMPOSE_RUN_TERRAFORM = docker-compose run --rm tf
COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose run --rm --entrypoint aws tf
COMPOSE_RUN_APP = docker-compose run --rm -p "3000:3000" app
COMPOSE_BUILD_APP = docker-compose build app
DOCKER_CLEAN = docker-compose down --remove-orphans && docker image prune && docker network prune

# Variables 
IMAGE_TAG ?= latest
ECR_NAME = $(shell $(COMPOSE_RUN_TERRAFORM) output -raw ecr_name)
AWS_REGION = $(shell $(COMPOSE_RUN_TERRAFORM) output -raw region_name)
AWS_ACCOUNT_ID := $(shell $(COMPOSE_RUN_AWS) sts get-caller-identity --query Account --output text)
ECS_CLUSTER = $(shell $(COMPOSE_RUN_TERRAFORM) output -raw ecs_cluster)
ECS_SERVICE = $(shell $(COMPOSE_RUN_TERRAFORM) output -raw ecs_service)

# Terraform Pipeline and Local Commands
.PHONY: run_plan run_apply run_destroy_plan run_destroy_apply
run_plan: init plan

run_apply: init apply

run_destroy_plan: init destroy_plan

run_destroy_apply: init destroy_apply

# Docker Pipeline and Local Commands
.PHONY: run_app push_image
run_app: build run

push_image: build init tag aws_login push update_task

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

# Individual Docker Commands
.PHONY: build tag push run clean
build: 
	$(COMPOSE_BUILD_APP)

tag:
	docker tag app:latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_NAME):$(IMAGE_TAG)

push:
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(ECR_NAME):$(IMAGE_TAG)

run:
	$(COMPOSE_RUN_APP)

clean:
	$(DOCKER_CLEAN)

# AWS and Variable Commands
.PHONY: aws_login
aws_login: version
	$(COMPOSE_RUN_AWS) ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

update_task:
	$(COMPOSE_RUN_AWS) ecs update-service --region $(AWS_REGION) --cluster $(ECS_CLUSTER) --service $(ECS_SERVICE) --force-new-deployment
