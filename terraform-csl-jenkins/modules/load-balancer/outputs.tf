output "aws_lb_dns_name" {
  value = aws_lb.project_lb.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.project_lb.zone_id
}