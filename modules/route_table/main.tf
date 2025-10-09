#created 4 RT
resource "aws_route_table" "RT-1" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "RT-1"
  }

}

resource "aws_route_table" "RT-2" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "RT-2"
  }

}

resource "aws_route_table" "RT-3" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "RT-3"
  }

}

resource "aws_route_table" "RT-4" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.nat_gateway_2_id
  }

  tags = {
    Name = "RT-4"
  }

}

#Route table association
resource "aws_route_table_association" "rta-1" {
  subnet_id      = var.public_subnet_1_id
  route_table_id = aws_route_table.RT-1.id
}


resource "aws_route_table_association" "rta-2" {
  subnet_id      = var.public_subnet_2_id
  route_table_id = aws_route_table.RT-2.id
}

resource "aws_route_table_association" "rta-3" {
  subnet_id      = var.private_subnet_1_id
  route_table_id = aws_route_table.RT-3.id
}

resource "aws_route_table_association" "rta-4" {
  subnet_id      = var.private_subnet_2_id
  route_table_id = aws_route_table.RT-4.id
}