resource "aws_security_group" "alb_sg" {
  name        = "${var.tags.Owner}-${var.tags.Project}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description      = "Internet Web Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.tags.Owner}-${var.tags.Project}-ecs-sg"
  description = "Allow HTTP traffic to ECS"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value

  ingress {
    description      = "Internet Web Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [ aws_security_group.alb_sg.id ]
  }

  tags = var.tags
}