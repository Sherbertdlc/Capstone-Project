region = "us-east-1"
vpc-name = "3-tier-vpc"
vpc_cidr_block = "10.0.0.0/16"
igw-name = "3-tier-igw"
nat-gw-name = "3-tier-natgw"
az_1 = "us-east-1a"
az_2 = "us-east-1b"

image-id = "ami-02d7fd1c2af6eead0"
instance-type = "t2.micro"
instance-type-db = "db.t3.micro"

web-subnet1-cidr = "10.0.1.0/24"
web-subnet1-name = "3-tier-web-subnet-1"
web-subnet2-cidr = "10.0.2.0/24"
web-subnet2-name = "3-tier-web-subnet-2"

app-subnet1-cidr = "10.0.3.0/24"
app-subnet1-name = "3-tier-app-subnet-1"
app-subnet2-cidr = "10.0.4.0/24"
app-subnet2-name = "3-tier-app-subnet-2"

db-subnet1-cidr = "10.0.5.0/24"
db-subnet1-name = "3-tier-db-subnet-1"
db-subnet2-cidr = "10.0.6.0/24"
db-subnet2-name = "3-tier-db-subnet-2"

public-rt-name = "3-tier-public-rt"
private-rt-name = "3-tier-private-rt"

key-name = "project-key"

launch-template-web-name = "3-tier-web-launch-template"
alb-web-name = "3-tier-web-alb"
alb-sg-web-name = "3-tier-web-alb-sg"
asg-web-name = "3-tier-web-asg"
asg-sg-web-name = "3-tier-web-asg-sg"
tg-web-name = "3-tier-web-tg"

launch-template-app-name = "3-tier-app-launch-template"
alb-app-name = "3-tier-app-alb"
alb-sg-app-name = "3-tier-app-alb-sg"
asg-app-name = "3-tier-app-asg"
asg-sg-app-name = "3-tier-app-asg-sg"
tg-app-name = "3-tier-app-tg"

db-name = "rdsdb"
db-sg-name = "3-tier-db-sg"
db-subnet-grp-name = "three-tier-db-subnet-group"
db-password =
db-username =