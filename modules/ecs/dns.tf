# Pull down the current hosted zone
data "aws_route53_zone" "selected" {
  name         = "avolent.cloud"
}

# Create records for to direct domain to lb
resource "aws_route53_record" "a" { 
    zone_id = data.aws_route53_zone.selected.zone_id
    name    = "weather.avolent.cloud"
    type    = "A"

    alias {
        name                   = aws_lb.alb.dns_name
        zone_id                = aws_lb.alb.zone_id
        evaluate_target_health = true
    }
}

# Create certificate for domain
resource "aws_acm_certificate" "app" {
  domain_name       = "weather.avolent.cloud"
  validation_method = "DNS"

  tags = var.tags
}

# Add records for certificate
resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.app.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}

# Validate Certificate
resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.app.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}