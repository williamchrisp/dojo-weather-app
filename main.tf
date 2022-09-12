# Grab Output data used for pushing image
data "aws_region" "current" {}

# Import my main infra module
module "vpc" {
  source = "github.com/williamchrisp/dojo-weather-infra?ref=master"

  tags = var.tags
}

# Import my ecs module
module "ecs" {
  source                 = "./modules/ecs"
  vpc_id                 = module.vpc.vpc_id
  ecs_availability_zones = var.ecs_availability_zones
  ecr_url                = module.ecr.ecr_url
  image_tag              = var.image_tag
  desired_count          = var.desired_count
  deployment_max         = var.deployment_max
  deployment_min         = var.deployment_min
  container_port         = var.container_port
  health_check_delay     = var.health_check_delay
  cpu                    = var.cpu
  memory                 = var.memory

  tags = var.tags
}

# Import my ecr module
module "ecr" {
  source = "./modules/ecr"

  tags = var.tags
}

# Output data used for pushing image
output "region_name" {
  description = "Current AWS Region"
  value       = data.aws_region.current.name
}

output "ecr_name" {
  description = "Container repository name"
  value       = module.ecr.ecr_name
}

output "ecs_cluster" {
  description = "ECS Cluster Name"
  value       = module.ecs.ecs_cluster
}

output "ecs_service" {
  description = "ECS Service Name"
  value       = module.ecs.ecs_service
}

output "alb_url" {
  description = "Application Load Balancer URL"
  value       = module.ecs.alb_url
}

output "vpc_id" {
  description = "The VPC ID in which the app is built under"
  value       = module.vpc.vpc_id
}

output "subnet_availability_zones" {
  description = "Availability Zones in which each subnet will lie. Order specifies subnet."
  value       = module.vpc.subnet_availability_zones
}

output "public_subnets" {
  description = "Specifies the public subnets in a list. Order specifies AZ"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Specifies the private subnets in a list. Order specifies AZ"
  value       = module.vpc.private_subnets
}