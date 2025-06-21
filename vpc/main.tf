# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.199.199.0/26"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "blue-green-rds-vpc" }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.199.199.32/28"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags                    = { Type = "Public" }
}

# Private Subnet 1
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.199.199.0/28"
  availability_zone = "eu-west-2a"
  tags              = { Type = "Private" }
}

# Private Subnet 2
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.199.199.16/28"
  availability_zone = "eu-west-2b"
  tags              = { Type = "Private" }
}

# Public Subnet setup
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}