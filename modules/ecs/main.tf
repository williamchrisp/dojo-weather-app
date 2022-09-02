# Pull Main stacks VPC id from SSM
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.tags.Owner}/${var.tags.Project}/vpc-id"
}