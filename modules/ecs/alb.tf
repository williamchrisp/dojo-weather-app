# IP Target group for ECS
resource "aws_lb_target_group" "tg" {
  name        = "${var.tags.Project}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  tags = var.tags
}

# ALB for the ECS Cluster
resource "aws_lb" "alb" {
  name               = "${var.tags.Project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [data.aws_subnets.public.ids[0], data.aws_subnets.public.ids[1]]

  tags = var.tags
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }

  tags = var.tags
}

# Output the ALB URL
output "alb_url" {
    description = "ALB URL"
    value = aws_lb.alb.dns_name
}