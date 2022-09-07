# Pull VPC ID located in SSM Parameter Store from Main Infra Stack
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.tags.Owner}/${var.tags.Project}/vpc-id"
}

# Grab current Region
data "aws_region" "current" {}

# Pull data on the Main Infra Private subnets, using only the specified AZs.
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_ssm_parameter.vpc_id.value]
  }
  filter {
    name = "availability-zone"
    values = var.availability_zones
  }
  tags = {
    Tier = "private"
  }
}

# Logs for the ECS containers
resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/${var.tags.Owner}-${var.tags.Project}"

  tags = var.tags
}

# ECS Cluster Creation
resource "aws_ecs_cluster" "cluster" {
  name = "${var.tags.Owner}-${var.tags.Project}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

# ECS Service definitions
resource "aws_ecs_service" "app" {
  name            = "${var.tags.Owner}-${var.tags.Project}"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  deployment_maximum_percent = var.deployment_max
  deployment_minimum_healthy_percent = var.deployment_min
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = var.health_check_delay
  depends_on      = [aws_iam_role.ecs_ecr_access]

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "${var.tags.Project}"
    container_port   = var.container_port
  }

  network_configuration {
    subnets = data.aws_subnets.private.ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  tags = var.tags
}

#ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family = "${var.tags.Owner}-${var.tags.Project}-fam"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = var.cpu
  memory = var.memory
  execution_role_arn = "${aws_iam_role.ecs_ecr_access.arn}"
  container_definitions = jsonencode([
    {
      name =  "${var.tags.Project}"
      image = "${aws_ecr_repository.ecr.repository_url}:${var.image_tag}"
      portMappings = [
        {
          containerPort = var.container_port
          protocol = "tcp"
        }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${aws_cloudwatch_log_group.app.name}"
          awslogs-stream-prefix = "ecs"
          awslogs-region        = "${data.aws_region.current.name}"
        }
      }
    }
  ])

  tags = var.tags
}