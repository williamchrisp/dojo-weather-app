# Container Repository for the image.
resource "aws_ecr_repository" "ecr" {
    name = "${var.tags.Owner}-${var.tags.Project}"
    force_delete = true
    image_scanning_configuration {
        scan_on_push = true
    }

    tags = var.tags
}

output "ecr_name" {
  description = "ECR Name"
  value = aws_ecr_repository.ecr.name
}

output "ecr_url" {
  description = "ECR URL"
  value = aws_ecr_repository.ecr.repository_url
}