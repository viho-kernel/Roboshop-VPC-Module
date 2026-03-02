variable "project" {
    type = string
  
}

variable "environment" {
    type = string
  
}

variable "cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_tags" {
    type = map(string)
    default = {}
}

variable "igw_tags" {
    type = map(string)
    default = {}  
}

variable "availability_zones" {
    type = list
    default = ["us-east-1a", "us-east-1b"]
  
}

variable "public_subnet_cidrs" {
    type = list 
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}

variable "az_tags" {
    type = map(string)
    default = {}
}

variable "private_subnet_cidrs" {
    type = list 
    default = ["10.0.11.0/24", "10.0.12.0/24"]
  
}

variable "database_subnet_cidrs" {
    type = list 
    default = ["10.0.21.0/24", "10.0.22.0/24"]
  
}

variable "public_route_table_tags" {
    type = map(string)

    default = {}
  
}

variable "eip_tags" {
    type = map(string)
    default = {}
  
}

variable "aws_nat_gateway_tags" {
    type = map(string)
    default = {}  
}

variable "private_route_table_tags" {
    type = map(string)
    default = {}
  
}

variable "database_route_table_tags" {
    type = map(string)
    default = {}
  
}

variable "is_peering_required" {
    default = false
    type = bool
  
}