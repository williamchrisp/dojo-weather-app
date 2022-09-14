# Grab data in the stack
data "aws_region" "current" {}

# Pull VPC ID located in SSM Parameter Store from Main Infra Stack
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.tags.Owner}/${var.tags.Project}/vpc-id"
}

# Import my ecs module
module "ecs" {
  source                 = "./modules/ecs"
  vpc_id                 = data.aws_ssm_parameter.vpc_id.value
  ecs_availability_zones = var.ecs_availability_zones
  ecr_url                = module.ecr.ecr_url
  image_tag              = var.image_tag
  desired_count          = var.desired_count
  deployment_max         = var.deployment_max
  deployment_min         = var.deployment_min
  autoscaling_max        = var.autoscaling_max
  autoscaling_min        = var.autoscaling_min
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