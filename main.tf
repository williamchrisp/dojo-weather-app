module "ecs" {
  source   = "./modules/ecs"
  ecr_name = var.ecr_name

  tags = var.tags
}