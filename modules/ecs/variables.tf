# Root variables passed in
variable "vpc_id" {}

variable "ecs_availability_zones" {}

variable "image_tag" {}

variable "desired_count" {}

variable "deployment_max" {}

variable "deployment_min" {}

variable "autoscaling_max" {}

variable "autoscaling_min" {}

variable "tags" {}

variable "container_port" {}

variable "health_check_delay" {}

variable "cpu" {}

variable "memory" {}

variable "ecr_url" {}