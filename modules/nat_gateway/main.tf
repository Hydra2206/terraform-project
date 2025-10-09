#created NAT gateway
resource "aws_nat_gateway" "NAT-1" {
  allocation_id = var.eip-1_id
  subnet_id     = var.public_subnet_1_id

  depends_on = [var.igw] # To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
                                          #The depends_on line in your NAT Gateway resource explicitly tells Terraform to wait until the specified resource—aws_internet_gateway.igw—has been created before it begins creating your NAT Gateway.
  tags = {
    Name = "NAT-1"
  }
}

resource "aws_nat_gateway" "NAT-2" {
  allocation_id = var.eip-2_id
  subnet_id     = var.public_subnet_2_id

  depends_on = [var.igw]

  tags = {
    Name = "NAT-2"
  }
}