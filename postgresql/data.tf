data "aws_vpc" "selected" {
  tags = {
    Name = "blue-green-rds-vpc"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Type"
    values = ["Private"]
  }
}