# Task: create ECS using Terraform.

# Amazon ECS is a service for running and maintaining a specified number of tasks. It is a scalable, high-performing container management service that supports Docker containers. 


# Please use the diagram to provision the infrastructure using terraform. 


#  cluster with task and service definition
 /* Components: 
	VPC with a public subnet as an isolated pool for my resources
•	Internet Gateway to contact the outer world
•	Security groups for RDS MySQL and for EC2s
•	Auto-scaling group for ECS cluster with launch configuration
•	RDS MySQL instance
•	ECR container registry
•	ECS */

# Creating networking for the project

resource "aws_vpc" "ecs-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "ecs-vpc"
  }
}

# Public Subnet 1 

resource "aws_subnet" "public-sub1" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-2a"



  tags = {
    Name = "public-sub1"
  }
}

# Public Subnet 2 

resource "aws_subnet" "public-sub2" {
  vpc_id            = aws_vpc.ecs-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2b"



  tags = {
    Name = "public-sub2"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "ecs-igw" {
  vpc_id = aws_vpc.ecs-vpc.id


  tags = {
    Name = "ecs-igw"
  }
}

# Route table 

resource "aws_route_table" "ecs-route-table" {
  vpc_id = aws_vpc.ecs-vpc.id

  tags = {
    Name = "ecs-route-table"
  }
}

# Associate public subnet1 with the route table 
resource "aws_route_table_association" "sub1_route_assoc" {
  subnet_id = aws_subnet.public-sub1.id
  route_table_id = aws_route_table.ecs-route-table.id

}

# Associate public subnet2 with the route table 
resource "aws_route_table_association" "sub2_route_assoc" {
  subnet_id = aws_subnet.public-sub2.id
  route_table_id = aws_route_table.ecs-route-table.id

}

# Associate the internet gateway to the public route table 
resource "aws_route" "ecs_igw_route_assoc" {
  route_table_id = aws_route_table.ecs-route-table.id
  gateway_id = aws_internet_gateway.ecs-igw.id
  destination_cidr_block = "0.0.0.0/0"
}








