terraform  {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

#vpc creation#

resource "aws_vpc" "vpc_name" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc-name
  }
}

#create IGW#

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_name.id
  tags = {
    Name = var.igw-name
  }
}

###elastic IP address###

resource "aws_eip" "eip-address" {
    domain     = "vpc"
    
  
}

#create NGW#

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.eip-address.id
  subnet_id     = aws_subnet.app-subnet-1.id

  tags = {
    Name = var.nat-gw-name
  }

  depends_on = [aws_internet_gateway.igw]
}

#web subnets#

resource "aws_subnet" "web-subnet-1" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = var.web-subnet1-cidr
  availability_zone = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = var.web-subnet1-name
  }
}

resource "aws_subnet" "web-subnet-2" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = var.web-subnet2-cidr
  availability_zone = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = var.web-subnet2-name
  }
}

#app subnets#

resource "aws_subnet" "app-subnet-1" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = var.app-subnet1-cidr
  availability_zone = var.az_1

  tags = {
    Name = var.app-subnet1-name
  }
}

resource "aws_subnet" "app-subnet-2" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = var.app-subnet2-cidr
  availability_zone = var.az_2

  tags = {
    Name = var.app-subnet2-name
  }
}

#database subnets#

resource "aws_subnet" "db-subnet-1" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = var.db-subnet1-cidr
  availability_zone = var.az_1

  tags = {
    Name = var.db-subnet1-name
  }
}

resource "aws_subnet" "db-subnet-2" {
  vpc_id     = aws_vpc.vpc_name.id
  cidr_block = var.db-subnet2-cidr
  availability_zone = var.az_2

  tags = {
    Name = var.db-subnet2-name
  }
}

#database subnet group#

resource "aws_db_subnet_group" "database-subnet-group" {
  name       = var.db-subnet-grp-name
  subnet_ids = [aws_subnet.db-subnet-1.id, aws_subnet.db-subnet-2.id]

}


#public route table#

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc_name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt-name"
  }
}
resource "aws_route_table_association" "public-rt-association1" {
  subnet_id      = aws_subnet.web-subnet-1.id
  route_table_id = aws_route_table.public-rt.id
}


resource "aws_route_table_association" "public-rt-association2" {
  subnet_id      = aws_subnet.web-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

#private route table#

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc_name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gateway.id
  }

   tags = {
    Name = "private-rt-name"
  }
}

resource "aws_route_table_association" "private-rt-association1" {
  subnet_id      = aws_subnet.app-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-rt-association2" {
  subnet_id      = aws_subnet.app-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}

#web security group#

resource "aws_security_group" "alb-web-sg" {
  name        = var.alb-sg-web-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc_name.id

  ingress {
    description = "http"
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

  tags = {
    Name = var.alb-sg-web-name
  }
}

#app security group#

resource "aws_security_group" "alb-app-sg" {
  name        = var.alb-sg-app-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc_name.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-app-sg.id]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb-sg-app-name
  }
}

#database security group#

resource "aws_security_group" "db-sg" {
  name        = var.db-sg-name
  description = "DataBase Security Group"
  vpc_id      = aws_vpc.vpc_name.id

  ingress {

    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.app-asg-security-group.id]
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.db-sg-name
  }
}

#web load balancer#

resource "aws_lb" "web-alb" {
  name               = var.alb-web-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-web-sg.id]
  subnets            = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]
}

#app load balancer#

resource "aws_lb" "app-alb" {
  name               = var.alb-app-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-app-sg.id]
  subnets            = [aws_subnet.app-subnet-1.id, aws_subnet.app-subnet-2.id]

}



#web auto scaling group#

resource "aws_autoscaling_group" "web-asg" {
  name =   var.asg-web-name
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  target_group_arns   = [aws_lb_target_group.web-target-group.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]

  launch_template {
    id      = aws_launch_template.web-launch-template.id
    version = "$Latest"
  }
}

#web auto scaling security group#

resource "aws_security_group" "web-asg-security-group" {
  name        = var.asg-sg-web-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc_name.id

  ingress {
    description = "HTTP from alb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = var.asg-sg-web-name
  }
}

#app auto scaling group#

resource "aws_autoscaling_group" "app-asg" {
  name =   var.asg-app-name
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  target_group_arns   = [aws_lb_target_group.app-target-group.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.app-subnet-1.id, aws_subnet.app-subnet-2.id]

  launch_template {
    id      = aws_launch_template.app-launch-template.id
    version = "$Latest"
  }
}


#app auto scaling security group#

resource "aws_security_group" "app-asg-security-group" {
  name        = var.asg-sg-app-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc_name.id

  ingress {
    description = "HTTP from alb"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = var.asg-sg-app-name
  }
}


#web launch template#

resource "aws_launch_template" "web-launch-template" {
  name          = var.launch-template-web-name
  image_id      = var.image-id
  instance_type = var.instance-type
  key_name      = var.key-name
  user_data     = filebase64("${path.module}/userdata.sh")

network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.web-asg-security-group.id]
  }

tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.launch-template-web-name
    }
  }
}

#app launch template#

resource "aws_launch_template" "app-launch-template" {
  name          = var.launch-template-app-name
  image_id      = var.image-id
  instance_type = var.instance-type
  key_name      = var.key-name

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.web-asg-security-group.id]
  }

  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.launch-template-app-name
    }
  }

} 

#web target group#

resource "aws_lb_target_group" "web-target-group" {
  name     = "tg-web-name"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_name.id
  health_check {
    path = "/"
    matcher = 200
  }

}

resource "aws_lb_listener" "my_web_alb_listener" {
 load_balancer_arn = aws_lb.web-alb.arn 
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.web-target-group.arn
 }
}

#app target group#

resource "aws_lb_target_group" "app-target-group" {
  name     = "tg-app-name"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_name.id
  health_check {
    path = "/"
    matcher = 200
  }
}

resource "aws_lb_listener" "my_app_alb_listener" {
 load_balancer_arn = aws_lb.app-alb.arn
 port              = "80"
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.app-target-group.arn
 }
}

#database instance#

resource "aws_db_instance" "database" {
  allocated_storage    = 10
  db_name              = var.db-name
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.instance-type-db
  username             = var.db-username
  password             = var.db-password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  multi_az = true
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name = aws_db_subnet_group.database-subnet-group.name
}


