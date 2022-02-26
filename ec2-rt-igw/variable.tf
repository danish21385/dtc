variable "region" {
  default = "us-west-1"
}

variable "cidr_block" {
    default = ["10.0.0.0/16","10.0.1.0/24"]
  
}

variable "instance_type" {
    default = "t2.micro"
}

variable "env" {}