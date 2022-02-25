provider "aws" {
    region = "us-west-1"

  
}

resource "aws_vpc" "redvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "RVPC"
    }
  
}

resource "aws_subnet" "Redsubnet" {
  vpc_id = aws_vpc.redvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
      Name = "RSubnet"
  }
}


resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.redvpc.id
  
}

resource "aws_route_table" "redRT" {
    vpc_id = aws_vpc.redvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }
}

resource "aws_route_table_association" "Redrttosubnet" {
    subnet_id = aws_subnet.Redsubnet.id
    route_table_id = aws_route_table.redRT.id
  
}

output "vpcid" {
    value = aws_vpc.redvpc.id
  
}
