provider "aws" {
    region = var.region
  
}

resource "aws_vpc" "redvpc" {
    cidr_block = var.cidr_block[0]
    tags = {
        Name = "${var.env}-VPC"
    }
  
}
resource "aws_subnet" "Redsubnet" {
  vpc_id = aws_vpc.redvpc.id
  cidr_block = var.cidr_block[1]
  map_public_ip_on_launch = true
  tags = {
      Name = "${var.env}-subnet"
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

resource "aws_security_group" "redsg1" {
    vpc_id = aws_vpc.redvpc.id
    ingress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "ssh"
      from_port = 22
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "tcp"
      security_groups = []
      self = false
      to_port = 22
    } ]

    egress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "all outbound"
      from_port = 0
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "-1"
      security_groups = []
      self = false
      to_port = 0
    } ]
}

/*data "aws_ami" "latest-amazon" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-*-x86_64-gp2"]
    }
  
}*/


resource "aws_instance" "appserver" {
    ami = "ami-0573b70afecda915d"
    instance_type = var.instance_type
    subnet_id = aws_subnet.Redsubnet.id
    vpc_security_group_ids = [aws_security_group.redsg1.id]
    key_name = "server-key-pair"
    tags = {
      "Name" = "${var.env}-AppServer"
    }
}
output "vpcid" {
    value = aws_vpc.redvpc.id
  
}

output "EC2IP" {
    value = aws_instance.appserver.public_ip
  
}