provider "aws" {
    region = "ap-south-1"

}

#created VPC
resource "aws_vpc" "project_vpc" {
  cidr_block = "10.0.0.0/24"
   
  tags = {
    Name = "project_vpc"
  }

}


#created 4 subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = "10.0.0.0/26"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public-subnet-1"
  }

}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = "10.0.0.64/26"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "public-subnet-2"
  }

}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = "10.0.0.128/26"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "private-subnet-1"
  }

}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.project_vpc.id
  cidr_block = "10.0.0.192/26"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-subnet-2"
  }

}

#created IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_vpc.id
  
  tags = {
    Name = "igw"
  }

}

#created 2 elastic-ip for NAt gateway
resource "aws_eip" "eip-1" {

    tags = {
    Name = "eip-1"
  }

}

resource "aws_eip" "eip-2" {
    
    tags = {
    Name = "eip-2"
  }

}

#created NAT gateway
resource "aws_nat_gateway" "NAT-1" {
  allocation_id = aws_eip.eip-1.id
  subnet_id     = aws_subnet.public-subnet-1.id

  depends_on = [aws_internet_gateway.igw]             # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.

  tags = {
    Name = "NAT-1"
  }
}

resource "aws_nat_gateway" "NAT-2" {
  allocation_id = aws_eip.eip-2.id
  subnet_id     = aws_subnet.public-subnet-2.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT-2"
  }
}

#created 4 RT
resource "aws_route_table" "RT-1" {
    vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT-1"
  }
  
}

resource "aws_route_table" "RT-2" {
    vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT-2"
  }
  
}

resource "aws_route_table" "RT-3" {
    vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-1.id
  }

  tags = {
    Name = "RT-3"
  }
  
}

resource "aws_route_table" "RT-4" {
    vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT-2.id
  }

  tags = {
    Name = "RT-4"
  }
  
}

#Route table association
resource "aws_route_table_association" "rta-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.RT-1.id
}


resource "aws_route_table_association" "rta-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.RT-2.id
}

resource "aws_route_table_association" "rta-3" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.RT-3.id
}

resource "aws_route_table_association" "rta-4" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.RT-4.id
}

#security group for launch template
resource "aws_security_group" "lt-sg" {
  name        = "launch-template-sg"
  description = "Allowing SSH & port 8000 for python app"
  vpc_id = aws_vpc.project_vpc.id

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
  image_id      = "ami-02d26659fd82cf299"
  instance_type = "t2.micro"
  key_name = "ec2_key"
  
  network_interfaces {
    security_groups = [aws_security_group.lt-sg.id]
  }

  tag_specifications {             #When instances are launched, they receive these tags. fir data sources me in tags ke help se instances ka details le sakta hu.
    resource_type = "instance"
    tags = {
      "Name"                          = "ec2-instance"
      "aws:autoscaling:groupName"    = "ec2-asg"
      "Environment"                   = "Testing"
    }
  }

}

#created auto scaling group using launch template
resource "aws_autoscaling_group" "ec2-asg" {
  name                 = "ec2-asg"
  vpc_zone_identifier = [aws_subnet.private-subnet-1.id , aws_subnet.private-subnet-2.id]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1

  health_check_type = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.ec2-launch-temaplate.id
    version = "$Latest"
  }

  tag {
    key                 = "ec2-asg"
    value               = "ec2-asg-instance"
    propagate_at_launch = true                                    #ensures that the tags are attached to the launched instances automatically.
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

#creating required resources for bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = aws_vpc.project_vpc.id   

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {                        #http bcoz index.html file download karega bastion
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "bastion" {
  ami                         = "ami-02d26659fd82cf299"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet-1.id        # Public subnet ID
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                   = "ec2_key"                            # Name of your EC2 keypair for SSH
  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"                            # username for your EC2 instance
    private_key = file("C:/Users/mittu/Documents/key-pair/ec2_key.pem")  # Replace with the path to your private key
    host        = self.public_ip       #self isliye bcoz hum already resource ke andar hai, resource ke andar nahi hote toh aws_instance.resource_name.public_ip yeh use karte
  }

  provisioner "file" {
    source      = "C:/Users/mittu/Documents/key-pair/ec2_key.pem"  # Replace with the path to your local file
    destination = "/home/ubuntu/ec2_key.pem"                       # Replace with the path on the remote instance
  }

/*
  provisioner "remote-exec" {
    inline = [

      "sudo ssh -i ec2_key.pem ubuntu@${data.aws_instances.asg-instances.instances[0]}"                            #interpolation
      "wget https://codeload.github.com/gist/b55828fa05ed3470d352/zip/3a7183fb56493ca42b5ddeeb73895f5a8cb1d6d3",
      "sudo apt install unzip",
      "unzip 3a7183fb56493ca42b5ddeeb73895f5a8cb1d6d3",
      "cd b55828fa05ed3470d352-3a7183fb56493ca42b5ddeeb73895f5a8cb1d6d3",
      "python3 -m http.server 8000"
      
    ]
  }
*/
}


#security group for load balancer
#for now i have allowed all traffic but later will only allow those protcols which are needed
resource "aws_security_group" "alb-sg" {                
  name        = "alb_sg"
  description = "Security group allowing all inbound traffic"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPv4 addresses
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
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public-subnet-1.id , aws_subnet.public-subnet-2.id]

}

#created target group for alb
resource "aws_lb_target_group" "alb-target-group" {
  name     = "alb-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.project_vpc.id

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
resource "aws_autoscaling_attachment" "tg-attachment" {                 #yaha pe joh bhi IC ASG ke through create honge woh sab IC LB ke liye target group me attach ho jayenge
  autoscaling_group_name = aws_autoscaling_group.ec2-asg.id
  lb_target_group_arn    = aws_lb_target_group.alb-target-group.arn
}

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

