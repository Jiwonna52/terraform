provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "vpc-main" {
  cidr_block = var.cidr_block

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name  = "main VPC"
    owner = "njw"
  }
}

#Public Subnet
resource "aws_subnet" "subnet-public01" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pub01-cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnet-01"
    owner = "njw"
  }
}

resource "aws_subnet" "subnet-public02" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pub02-cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-subnet-02"
    owner = "njw"
  }
}


#Private Subnet for web
resource "aws_subnet" "subnet-private03-web" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pri03-cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "pri-subnet-03-web"
    owner = "njw"
    type = "web"
  }
}

resource "aws_subnet" "subnet-private04-web" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pri04-cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "pri-subnet-04-web"
    owner = "njw"
    type = "web"
  }
}

#Private Subnet for APP
resource "aws_subnet" "subnet-private05-app" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pri05-cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "pri-subnet-05-app"
    owner = "njw"
    type = "app"
  }
}

resource "aws_subnet" "subnet-private06-app" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pri06-cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "pri-subnet-06-app"
    owner = "njw"
    type = "app"
  }
}

#Private Subnet for DB
resource "aws_subnet" "subnet-private07-db" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pri07-cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "pri-subnet-07-db"
    owner = "njw"
    type = "db"
  }
}

resource "aws_subnet" "subnet-private08-db" {
  vpc_id            = aws_vpc.vpc-main.id
  cidr_block        = var.subnet-pri08-cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "pri-subnet-08-db"
    owner = "njw"
    type = "db"
  }
}

#IGW
resource "aws_internet_gateway" "igw-main" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = "igw-main"
    owner = "njw"
    type = "igw"
  }
}

#EIP
resource "aws_eip" "eip01" {
  domain = "vpc"
  tags = {
    Name = "eip01"
    owner = "njw"
    type = "eip"
  }
}

resource "aws_eip" "eip02" {
  domain = "vpc"
  tags = {
    Name = "eip02"
    owner = "njw"
    type = "eip"
  }
}

#Nat Gateway
resource "aws_nat_gateway" "nat-gw01" {
  allocation_id     = aws_eip.eip01.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.subnet-public01.id
  depends_on = [aws_internet_gateway.igw-main]
  
  tags = {
    Name = "nat-gw01"
    owner = "njw"
    type = "nat-gw"
  }
}

resource "aws_nat_gateway" "nat-gw02" {
  allocation_id     = aws_eip.eip02.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.subnet-public02.id
  depends_on = [aws_internet_gateway.igw-main]
  
  tags = {
    Name = "nat-gw02"
    owner = "njw"
    type = "nat-gw"
  }
}

#Public Routing Table
resource "aws_route_table" "route-table-public" {
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-main.id 
  }

  tags = {
    Name = "public-route-table"
    owner = "njw"
    type = "route-table"
  }
}

resource "aws_route_table_association" "rt-pub-assco01" {
  subnet_id      = aws_subnet.subnet-public01.id
  route_table_id = aws_route_table.route-table-public.id
}

resource "aws_route_table_association" "rt-pub-assco02" {
  subnet_id      = aws_subnet.subnet-public02.id
  route_table_id = aws_route_table.route-table-public.id
}

#Private Routing Table
resource "aws_route_table" "route-table-private01" {
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw01.id
  }

  tags = {
    Name = "private-route-table01"
    owner = "njw"
    type = "route-table"
  }
}

resource "aws_route_table" "route-table-private02" {
  vpc_id = aws_vpc.vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw02.id
  }

  tags = {
    Name = "private-route-table02"
    owner = "njw"
    type = "route-table"
  }
}

# 라우팅 테이블 WEB 연결
resource "aws_route_table_association" "rt-pri-assco01-web" {
  subnet_id      = aws_subnet.subnet-private03-web.id
  route_table_id = aws_route_table.route-table-private01.id
}

resource "aws_route_table_association" "rt-pri-assco02-web" {
  subnet_id      = aws_subnet.subnet-private04-web.id
  route_table_id = aws_route_table.route-table-private02.id
}

# 라우팅 테이블 APP 연결
resource "aws_route_table_association" "rt-pri-assco01-app" {
  subnet_id      = aws_subnet.subnet-private05-app.id
  route_table_id = aws_route_table.route-table-private01.id
}

resource "aws_route_table_association" "rt-pri-assco02-app" {
  subnet_id      = aws_subnet.subnet-private06-app.id
  route_table_id = aws_route_table.route-table-private02.id
}

# 베스천 호스트 용
resource "aws_route_table_association" "rt-pri-assco01-db" {
  subnet_id      = aws_subnet.subnet-private07-db.id
  route_table_id = aws_route_table.route-table-private01.id
}

resource "aws_route_table_association" "rt-pri-assco02-db" {
  subnet_id      = aws_subnet.subnet-private08-db.id
  route_table_id = aws_route_table.route-table-private02.id
}


# ALB WEB 보안 그룹룹
resource "aws_security_group" "alb-sg-web" {
  name        = "alb-sg-web"
  description = "ALB Security Group for web"
  vpc_id      = aws_vpc.vpc-main.id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTPS from Internet"
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
    Name = "alb-sg-web"
    owner = "njw"
    type = "security-group"
  }
}

#ASG WEB 보안 그룹룹
resource "aws_security_group" "asg-sg-web" {
  name        = "asg-sg-web"
  description = "ASG Security Group for web"
  vpc_id      = aws_vpc.vpc-main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg-web.id]
  }
  
  ingress {
    description = "Https from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.alb-sg-web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    Name = "asg-sg-web"
    owner = "njw"
    type = "security-group"
  }
}

#ALB APP 보안 그룹룹
resource "aws_security_group" "alb-sg-app" {
  name        = "alb-sg-app"
  description = "ALB Security Group for app"
  vpc_id      = aws_vpc.vpc-main.id

  ingress {
    description     = "HTTP from Internet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg-web.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    Name = "alb-sg-app"
    owner = "njw"
    type = "security-group"
  }
}

#ASG APP 보안 그룹룹
resource "aws_security_group" "asg-sg-app" {
  name        = "asg-sg-app"
  description = "ASG Security Group for app"
  vpc_id      = aws_vpc.vpc-main.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg-app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    Name = "asg-sg-app"
    owner = "njw"
    type = "security-group"
  }
}

#db 보안 그룹룹
resource "aws_security_group" "sg-db" {
  name        = "db-sg"
  description = "Security Group for db"
  vpc_id      = aws_vpc.vpc-main.id

  ingress {
    description     = "DB from ASG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg-app.id]
  }
  
  ingress {
    description     = "DB from bastion host"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    Name = "db-sg"
    owner = "njw"
    type = "security-group"
  }
}


#DB 접근 보안 그룹
resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Security Group for DB Bastion host"
  vpc_id      = aws_vpc.vpc-main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    Name = "bastion-sg"
    owner = "njw"
    type = "security-group"
  }
}
