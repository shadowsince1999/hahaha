# main.tf

provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-gateway"
  }
}

# Create Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "main-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create Security Group
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-security-group"
  }
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-04a81a99f5ec58529" # Replace with an appropriate AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = ["${aws_security_group.sg.name}"]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker
              service docker start
              usermod -a -G docker ec2-user
              EOF

  tags = {
    Name = "web-instance"
  }
}

# # Create ECS Cluster
# resource "aws_ecs_cluster" "main" {
#   name = "main-cluster"
# }

# Create RDS Instance
resource "aws_db_instance" "main" {
  identifier = "main-rds-instance"
  engine     = "mysql"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_type = "gp2"
  username = "admin"
  password = "shadow@1122"  # Make sure to use a secure password or refer to a secrets manager
  db_name   = "main_db"
  vpc_security_group_ids = [aws_security_group.sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot = true
  tags = {
    Name = "main-rds-instance"
  }
}

# Create DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name        = "main-db-subnet-group"
  subnet_ids  = [aws_subnet.main.id]
  tags = {
    Name = "main-db-subnet-group"
  }
}

# Create S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = "my-unique-bucket-name-123456"  # Ensure this bucket name is unique across AWS
  tags = {
    Name = "main-s3-bucket"
  }
}
