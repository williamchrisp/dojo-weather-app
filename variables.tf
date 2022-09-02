#Tag Variables
variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default = {
    Owner   = "williamchrisp"
    Project = "node-weather-app"
  }
}