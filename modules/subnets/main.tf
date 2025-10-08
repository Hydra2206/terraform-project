#created 4 subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.subnet-1-cidr
  availability_zone = var.subnet-1-az

  tags = {
    Name = "public-subnet-1"
  }

}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.subnet-2-cidr
  availability_zone = var.subnet-2-az

  tags = {
    Name = "public-subnet-2"
  }

}

resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.subnet-3-cidr
  availability_zone = var.subnet-3-az

  tags = {
    Name = "private-subnet-1"
  }

}

resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.subnet-4-cidr
  availability_zone = var.subnet-4-az

  tags = {
    Name = "private-subnet-2"
  }

}