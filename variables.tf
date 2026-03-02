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

variable "public_subnet_cidrs" {
    type = list 
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}

variable "availability_zones" {
    type = list
    default = ["us-east-1a", "us-east-1b"]
  
}