output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}