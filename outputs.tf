

# Output the private IPs as a list
output "asg-instance-private-ips-1" {
  value = data.aws_instances.asg-instances.private_ips[0]
}

output "asg-instance-private-ips-2" {
  value = data.aws_instances.asg-instances.private_ips[1]
}

output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}

output "load_balancer_dns" {
  value = aws_lb.application-lb.dns_name

}

