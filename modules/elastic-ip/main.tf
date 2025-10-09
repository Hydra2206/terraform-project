#created 2 elastic-ip for NAt gateway
resource "aws_eip" "eip-1" {

  tags = {
    Name = "eip-1"
  }

}

resource "aws_eip" "eip-2" {

  tags = {
    Name = "eip-2"
  }

}