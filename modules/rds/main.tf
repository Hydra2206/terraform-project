#creating rds subnet group for rds instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id]
  tags = {
    Name = "rds-subnet-group"
  }
}

#creating sg for rds instance
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Allow DB access from EC2"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.lt-sg_id] # EC2 SG ID yaha pe specific ec2 sg se hi traffic aa sakta, anywhere kahi se bhi nahi aa sakta
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating RDS Mysql instance
resource "aws_db_instance" "DB-instance" {

  identifier             = "my-rds-db"
  engine                 = var.rds-engine
  instance_class         = var.rds-instance-class
  username               = var.rds-username
  password               = var.rds-password
  allocated_storage      = 20
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  publicly_accessible      = false
  skip_final_snapshot      = true
}