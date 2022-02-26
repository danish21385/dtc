provider "aws"{
    region = var.region
}

variable "environment" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "region" {}
variable "instance_type" {}

resource "aws_vpc" "vpc1"{
    cidr_block = var.vpc_cidr_block
     tags = {
      "Name" = "${var.environment}-vpc"
    }
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = var.subnet_cidr_block
    map_public_ip_on_launch = true
    tags = {
      "Name" = "${var.environment}-subnet"
    }
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.vpc1.id
    route = [ {
      carrier_gateway_id = ""
      cidr_block = "0.0.0.0/0"
      destination_prefix_list_id = ""
      egress_only_gateway_id = ""
      gateway_id = aws_internet_gateway.myigw.id
      instance_id = ""
      ipv6_cidr_block = ""
      local_gateway_id = ""
      nat_gateway_id = ""
      network_interface_id = ""
      transit_gateway_id = ""
      vpc_endpoint_id = ""
      vpc_peering_connection_id = ""
    } ]
}

resource "aws_route_table_association" "subn1myrt" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.myrt.id
  
}

resource "aws_security_group" "Allowssh" {
    vpc_id = aws_vpc.vpc1.id
    ingress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "Allow ssh from anywhere"
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
      description = "Allow all outbound"
      from_port = 0
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "-1"
      security_groups = [ ]
      self = false
      to_port = 0
    } ]
  
}

resource "aws_instance" "WebAp" {
    ami = "ami-009726b835c24a3aa"
    instance_type = var.instance_type
    subnet_id = aws_subnet.subnet1.id
    vpc_security_group_ids = [aws_security_group.Allowssh.id]
    key_name = "server-key-pair"
    tags = {
      "Name" = "${var.environment}-Web"
    }
}

