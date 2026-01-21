
resource "aws_route53_zone" "primary" {
  name    = "example.com"  
  comment = "Primary hosted zone for my project"
}


resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id  
  name    = "www.example.com"
  type    = "A"

  alias {
    name                   = module.alb.dns_name   
    zone_id                = module.alb.zone_id     
    evaluate_target_health = true
  }
}
