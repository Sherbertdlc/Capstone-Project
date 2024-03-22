variable "region" {
  description = "aws_region"
}

variable "vpc-name" {
    description = "vpc name"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

variable "nat-gw-name" {
  description = "NAT Gateway name"
}

variable "instance-type" {
  description = "ec2 Instance type"
}

variable "az_1" {
    description = "availability zone 1"
}

variable "az_2" {
    description = "availability zone 2"
}


variable "igw-name" {
  description = "internet gateway name"
  
}
variable "image-id" {
    description = "ami image id"
}

variable "key-name" {
  description = "key pair"
}

variable "web-subnet1-cidr" {
  description = "CIDR Block for Web-tier Subnet-1"
}

variable "web-subnet1-name" {
  description = "Name for Web-tier Subnet-1"
}

variable "web-subnet2-cidr" {
  description = "CIDR Block for Web-tier Subnet-2"
}

variable "web-subnet2-name" {
  description = "Name for Web-tier Subnet-2"
}

variable "app-subnet1-cidr" {
  description = "CIDR Block for Application-tier Subnet-1"
}

variable "app-subnet1-name" {
  description = "Name for app-tier Subnet-1"
}

variable "app-subnet2-cidr" {
  description = "CIDR Block for Application-tier Subnet-2"
}

variable "app-subnet2-name" {
  description = "Name for Application-tier Subnet-2"
}


variable "db-subnet1-cidr" {
  description = "CIDR Block for Database-tier Subnet-1"
}

variable "db-subnet1-name" {
  description = "Name for Database-tier Subnet-1"
}

variable "db-subnet2-cidr" {
  description = "CIDR Block for Database-tier Subnet-2"
}

variable "db-subnet2-name" {
  description = "Name for Database-tier Subnet-2"
}

variable "public-rt-name" {
  description = "Name for Public Route table"
}

variable "private-rt-name" {
  description = "Name for Private Route table"
}

variable "launch-template-web-name" {
  description = "web launch template"
}

variable "alb-web-name" {
  description = "alb for the Web Tier"
}

variable "alb-sg-web-name" {
  description = "alb security group 1"
}

variable "asg-web-name" {
  description = "asg in Web Tier"
}

variable "asg-sg-web-name" {
  description = "asg security group 1 name"
}

variable "tg-web-name" {
  description = "target group for web"
}

variable "launch-template-app-name" {
  description = "app launch template"
}

variable "alb-app-name" {
  description = "Name the Load Balancer for the App Tier"
}

variable "alb-sg-app-name" {
  description = "Name for alb security group 1"
}

variable "asg-app-name" {
  description = "Name the Auto Scaling group in app Tier"
}

variable "asg-sg-app-name" {
  description = "Name for asg security group 1"
}

variable "tg-app-name" {
  description = "Name for Target group app"
}

variable "db-username" {
  description = "Username for db instance"
}

variable "db-password" {
  description = "Password for db instance"
}

variable "db-name" {
  description = "Name for Database"
}

variable "instance-type-db" {
  description = "db instance type"
}

variable "db-sg-name" {
  description = "Name for DB Security group"
}

variable "db-subnet-grp-name" {
  description = "Name for DB Subnet Group"
}
