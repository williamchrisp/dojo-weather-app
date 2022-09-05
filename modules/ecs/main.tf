# Pull VPC ID located in SSM Parameter Store from Main Infra Stack
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.tags.Owner}/${var.tags.Project}/vpc-id"
}
