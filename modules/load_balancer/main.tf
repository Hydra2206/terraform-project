#security group for load balancer
resource "aws_security_group" "alb-sg" {
  name        = "alb_sg"
  description = "Security group allowing all inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"          
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "alb-sg"
  }
}

#created Application load balancer
resource "aws_lb" "application-lb" {
  name               = "ALB"
  internal           = false
  load_balancer_type = var.lb-type
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

}

#created target group for alb
resource "aws_lb_target_group" "alb-target-group" {
  name     = "alb-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

}

#created listener for alb
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.application-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "tg-attachment" { #yaha pe joh bhi IC ASG ke through create honge woh sab IC LB ke liye target group me attach ho jayenge
  autoscaling_group_name = var.asg_id
  lb_target_group_arn    = aws_lb_target_group.alb-target-group.arn
}