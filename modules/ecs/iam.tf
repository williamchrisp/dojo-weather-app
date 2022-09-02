# Roles to allow ECS access to ECR
resource "aws_iam_role" "ecs-ecr-access" {
  name = "${var.tags.Owner}-${var.tags.Project}-EcsExecutionRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
    })

  tags = var.tags
}

# Policy for ECR Access
resource "aws_iam_role_policy" "ecr" {
  name = "${var.tags.Owner}-${var.tags.Project}-EcsEcrAccess"
  role = aws_iam_role.ecs-ecr-access.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Effect = "Allow",
            Action = [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            Resource = "*"
        },
    ]
    })
}