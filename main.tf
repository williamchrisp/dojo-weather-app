# Grab Output data used for pushing image
data "aws_region" "current" {}

# Import my ecs module
module "ecs" {
  source             = "./modules/ecs"
  availability_zones = var.availability_zones
  image_tag          = var.image_tag
  desired_count      = var.desired_count
  deployment_max     = var.deployment_max
  deployment_min     = var.deployment_min
  container_port     = var.container_port
  health_check_delay = var.health_check_delay
  cpu                = var.cpu
  memory             = var.memory

  tags = var.tags
}

# Output data used for pushing image
output "region_name" {
  description = "Current AWS Region"
  value       = data.aws_region.current.name
}

output "ecr_name" {
  description = "ECR Name"
  value       = module.ecs.ecr_name
}

output "alb_url" {
  description = "ALB URL"
  value       = module.ecs.alb_url
}