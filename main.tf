# Grab Output data used for pushing image
data "aws_region" "current" {}

# Import my ecs module
module "ecs" {
  source = "./modules/ecs"

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