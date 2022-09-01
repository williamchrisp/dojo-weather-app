#ECS Variables
variable "ecr_name" {
  type        = string
  description = "Specifies the repository name"
  default     = "williamchrisp-node-weather-app"
}

#Tag Variables
variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default = {
    Owner   = "williamchrisp"
    Project = "Weather App"
  }
}