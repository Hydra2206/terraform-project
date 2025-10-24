provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/24"
}

module "subnets" {
  source        = "./modules/subnets"
  subnet-1-cidr = "10.0.0.0/26"
  subnet-2-cidr = "10.0.0.64/26"
  subnet-3-cidr = "10.0.0.128/26"
  subnet-4-cidr = "10.0.0.192/26"
  subnet-1-az   = "ap-south-1a"
  subnet-2-az   = "ap-south-1b"
  subnet-3-az   = "ap-south-1a"
  subnet-4-az   = "ap-south-1b"
  vpc_id        = module.vpc.vpc_id
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "elastic-ip" {
  source = "./modules/elastic-ip"
}

module "nat_gateway" {
  source             = "./modules/nat_gateway"
  eip-1_id           = module.elastic-ip.eip-1_id
  eip-2_id           = module.elastic-ip.eip-2_id
  public_subnet_1_id = module.subnets.public_subnet_1_id
  public_subnet_2_id = module.subnets.public_subnet_2_id
  igw                = module.igw
}

module "route-table" {
  source              = "./modules/route_table"
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.igw.igw_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  nat_gateway_2_id    = module.nat_gateway.nat_gateway_2_id
  public_subnet_1_id  = module.subnets.public_subnet_1_id
  public_subnet_2_id  = module.subnets.public_subnet_2_id
  private_subnet_1_id = module.subnets.private_subnet_1_id
  private_subnet_2_id = module.subnets.private_subnet_2_id
}

data "aws_ssm_parameter" "ec2_key" { #retrieving key pair details from aws
  name            = "/ec2/keypair/mykey"
  with_decryption = true
}

module "autoscaling_group" {
  source              = "./modules/asg"
  ami                 = "ami-02d26659fd82cf299"
  instance_type       = "t2.micro"
  key_name            = "ec2_key"
  vpc_id              = module.vpc.vpc_id
  private_subnet_1_id = module.subnets.private_subnet_1_id
  private_subnet_2_id = module.subnets.private_subnet_2_id
}

module "bastion_instance" {
  source             = "./modules/bastion_instance"
  ami                = "ami-02d26659fd82cf299"
  instance_type      = "t2.micro"
  key_name           = "ec2_key"
  vpc_id             = module.vpc.vpc_id
  public_subnet_1_id = module.subnets.public_subnet_1_id
}

module "load_balancer" {
  source             = "./modules/load_balancer"
  lb-type            = "application"
  vpc_id             = module.vpc.vpc_id
  asg_id             = module.autoscaling_group.asg_id
  public_subnet_1_id = module.subnets.public_subnet_1_id
  public_subnet_2_id = module.subnets.public_subnet_2_id
}

module "rds_instance" {
  source              = "./modules/rds"
  rds-engine          = "mysql"
  rds-instance-class  = "db.t4g.micro"
  rds-username        = "mittu"
  rds-password        = "mittukumar"
  vpc_id              = module.vpc.vpc_id
  private_subnet_1_id = module.subnets.private_subnet_1_id
  private_subnet_2_id = module.subnets.private_subnet_2_id
  lt-sg_id            = module.autoscaling_group.lt-sg_id
}