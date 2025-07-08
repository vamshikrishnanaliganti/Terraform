resource "aws_route53_zone" "public_zone" {
  name = "abadgvsvyvdugv.co.in"
}


resource "aws_route53_record" "frontend_dns" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "www.abadgvsvyvdugv.co.in"
  type    = "A"

  alias {
    name                   = aws_lb.frontend-alb.dns_name
    zone_id                = aws_lb.frontend-alb.zone_id
    evaluate_target_health = true
  }
}
