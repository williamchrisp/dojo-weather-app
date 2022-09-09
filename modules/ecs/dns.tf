# Pull down the current hosted zone
data "aws_route53_zone" "selected" {
  name         = "avolent.cloud"
}

# Create records for hosted zone
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