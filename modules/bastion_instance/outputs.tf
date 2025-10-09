output "bastion-public-ip" {
    description = "Public ip of bastion instance"
  value = aws_instance.bastion.public_ip
}