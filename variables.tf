# MAIN INFRA LAYER VARIABLES
# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "Specifies the cidr for the vpc"
  default     = "10.0.0.0/24"
}

variable "public_subnets" {
  type        = list(any)
  description = "Specifies the public subnets in a list"
  default     = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]
}

variable "private_subnets" {
  type        = list(any)
  description = "Specifies the private subnets in a list"
  default     = ["10.0.0.64/26", "10.0.0.128/26", "10.0.0.192/26"]
}

# S3 Variables
variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "williamdojoapp"
}

# APPLICATION LAYER VARIABLES
# Availability zones you want the app deployed too. Must subnets must be available in infra.
variable "availability_zones" {
  type        = list(any)
  description = "Availability zones you want the app deployed too."
  default     = ["us-east-1a", "us-east-1b"]
}

# Docker Image Tag
variable "image_tag" {
  type        = string
  description = "Sets the image tag you would like to use."
  default     = "latest"
}

# Task specifications
variable "desired_count" {
  type        = number
  description = "Number of instances of the task definition to place and keep running."
  default     = 1
}

variable "deployment_max" {
  type        = number
  description = "Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
  default     = 200
}

variable "deployment_min" {
  type        = number
  description = "Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  default     = 100
}

variable "container_port" {
  type        = number
  description = "The exposed port on the container."
  default     = 3000
}

variable "health_check_delay" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown."
  default     = 60
}

variable "cpu" {
  type        = number
  description = "The required CPU units for the container"
  default     = 256
}

variable "memory" {
  type        = number
  description = "The required memory count for the container"
  default     = 512
}

#Tag Variables (Owner + Project used to name resources)
variable "tags" {
  type        = map(string)
  description = "Tags to identify project resources"
  default = {
    Owner   = "williamchrisp"
    Project = "node-weather-app"
  }
}