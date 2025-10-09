#security group for launch template
resource "aws_security_group" "lt-sg" {
  name        = "launch-template-sg"
  description = "Allowing SSH & port 8000 for python app"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "launch-template-sg"
  }
}

#created aws launch template for ASG
resource "aws_launch_template" "ec2-launch-temaplate" {
  name_prefix   = "ec2-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = [aws_security_group.lt-sg.id]
  }

  tag_specifications { #When instances are launched, they receive these tags. fir data sources me in tags ke help se instances ka details le sakta hu.
    resource_type = "instance"
    tags = {
      "Name"                      = "ec2-instance"
      "aws:autoscaling:groupName" = "ec2-asg"
      "Environment"               = "Testing"
    }
  }

}

#created auto scaling group using launch template
resource "aws_autoscaling_group" "ec2-asg" {
  name                = "ec2-asg"
  vpc_zone_identifier = [var.private_subnet_1_id, var.private_subnet_2_id]
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ec2-launch-temaplate.id
    version = "$Latest"
  }

  tag {
    key                 = "ec2-asg"
    value               = "ec2-asg-instance"
    propagate_at_launch = true #ensures that the tags are attached to the launched instances automatically.
  }

}

# Data source to fetch all running EC2 instances with the ASG's tag
data "aws_instances" "asg-instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.ec2-asg.name]
  }

  instance_state_names = ["running"]

  depends_on = [aws_autoscaling_group.ec2-asg]

}