# Container Repository for the image.
resource "aws_ecr_repository" "ecr" {
    name = "${var.tags.Owner}-${var.tags.Project}"
    force_delete = true
    image_scanning_configuration {
        scan_on_push = true
    }

    tags = var.tags
}