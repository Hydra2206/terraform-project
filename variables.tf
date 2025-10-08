variable "region" {

}

variable "cidr_block" {
  description = "value for the vpc cidr"
}

variable "subnet-1-cidr" {
  description = "cidr value for subnet 1"
}

variable "subnet-2-cidr" {
  description = "cidr value for subnet 2"
}

variable "subnet-3-cidr" {
  description = "cidr value for subnet 3"
}

variable "subnet-4-cidr" {
  description = "cidr value for subnet 4"
}

variable "subnet-1-az" {
  description = "az for subnet 1"
}

variable "subnet-2-az" {
  description = "az for subnet 2"
}

variable "subnet-3-az" {
  description = "az for subnet 3"
}

variable "subnet-4-az" {
  description = "az for subnet 4"
}

variable "ami" {
  description = "ami value for launch template & asg"
}

variable "instance_type" {
  description = "instance type for launch template & asg"
}

variable "key_name" {
  description = "key name"
}

variable "lb-type" {
  description = "load balancer type"
}

variable "rds-engine" {
  description = "engine name"
}

variable "rds-instance-class" {
  description = "rds db instance class type"
}

variable "rds-username" {
  description = "db-username"
}

variable "rds-password" {
  description = "db-password"
}