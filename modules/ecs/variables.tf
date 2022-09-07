# Availability zones you want the app deployed too. Must subnets must be available in infra.
variable "availability_zones" {
  default = []
}

variable "tags" {
  default     = {}
}
