# Availability zones you want the app deployed too. Must subnets must be available in infra.
variable "availability_zones" {
  type        = list(any)
  description = "Availability zones you want the app deployed too."
  default     = ["us-east-1a", "us-east-1b"]
}

#Tag Variables
variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default = {
    Owner   = "williamchrisp"
    Project = "node-weather-app"
  }
}