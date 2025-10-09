output "asg_id" {
  value = aws_autoscaling_group.ec2-asg.id
}

# Output the private IPs as a list
output "asg-instance-private-ips-1" {
  value = data.aws_instances.asg-instances.private_ips[0]
}

output "asg-instance-private-ips-2" {
  value = data.aws_instances.asg-instances.private_ips[1]
}

output "lt-sg_id" {
  value = aws_security_group.lt-sg.id
}