variable "region" {

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