COMPOSE_RUN_TERRAFORM = docker-compose run --rm tf
COMPOSE_RUN_BASH = docker-compose run --rm --entrypoint bash tf
COMPOSE_RUN_AWS = docker-compose run --rm --entrypoint aws tf
COMPOSE_RUN_APP = docker-compose run --rm -p "8080:3000" app
COMPOSE_BUILD_APP = docker-compose build app
DOCKER_TAG_APP = docker tag weather-app:1 ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:1
DOCKER_PUSH_APP = docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:1
DOCKER_CLEAN = docker-compose down --remove-orphans && docker image prune -a
ECR_LOGIN = aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

.PHONY: run_plan
run_plan: init plan

.PHONY: run_apply
run_apply: init apply

.PHONY: run_destroy_plan
run_destroy_plan: init destroy_plan

.PHONY: run_destroy_apply
run_destroy_apply: init destroy_apply

.PHONY: version
version:
	$(COMPOSE_RUN_TERRAFORM) --version
	
.PHONY: init
init:
	$(COMPOSE_RUN_TERRAFORM) init -input=false
	-$(COMPOSE_RUN_TERRAFORM) validate
	-$(COMPOSE_RUN_TERRAFORM) fmt

.PHONY: plan
plan:
	$(COMPOSE_RUN_TERRAFORM) plan -out=tfplan -input=false

.PHONY: apply
apply:
	$(COMPOSE_RUN_TERRAFORM) apply "tfplan"

.PHONY: destroy_plan
destroy_plan:
	$(COMPOSE_RUN_TERRAFORM) plan -destroy

.PHONY: destroy_apply
destroy_apply:
	$(COMPOSE_RUN_TERRAFORM) destroy -auto-approve

.PHONY: run_app
run_app: build run

.PHONY: push_app
push_app: build tag push

.PHONY: build
build:
	$(COMPOSE_BUILD_APP)

.PHONY: tag
tag:
	${DOCKER_TAG_APP}

.PHONY: push
push:
	${ECR_LOGIN}
	${DOCKER_PUSH_APP}

.PHONY: run
run:
	${COMPOSE_RUN_APP}

.PHONE: clean
clean:
	${DOCKER_CLEAN}
