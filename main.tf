resource "aws_vpc" "main" {
  cidr_block = var.cidr
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    },
    var.vpc_tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    var.igw_tags,
    {
      Name = "${var.project}-${var.environment}-IGW"
    }
  )
  
}

resource "aws_subnet" "public" {
  #for_each = toset(var.availability_zones)
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge (
    local.common_tags,
    {
      # Roboshop-dev-us-east-1a
      Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    },
    var.az_tags
  )
    
}

resource "aws_subnet" "private" {
  #for_each = toset(var.availability_zones)
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false

  tags = merge (
    local.common_tags,
    {
      # Roboshop-dev-us-east-1a
      Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
    },
    var.az_tags
  )
    
}


resource "aws_subnet" "database" {
  #for_each = toset(var.availability_zones)
  count = length(var.database_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false

  tags = merge (
    local.common_tags,
    {
      # Roboshop-dev-us-east-1a
      Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
    },
    var.az_tags
  )
    
}


resource "aws_route_table" "test" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = aws_vpc.test.cidr_block
    network_interface_id = aws_network_interface.test.id
  }
}