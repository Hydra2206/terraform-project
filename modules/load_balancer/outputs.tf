output "load_balancer_dns" {
  value = aws_lb.application-lb.dns_name

}