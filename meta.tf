terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    bucket = "pathways-dojo"
    key    = "williamchrisp-tfstate-app"
    region = "us-east-1"
  }
}