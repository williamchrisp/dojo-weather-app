resource "aws_security_group" "alb_sg" {
  name        = "${var.tags.Owner}-${var.tags.Project}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Internet Web Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.tags.Owner}-${var.tags.Project}-ecs-sg"
  description = "Allow HTTP traffic to ECS"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Internet Web Traffic"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}