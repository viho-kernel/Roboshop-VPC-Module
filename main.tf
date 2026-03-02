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


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-Public-RoutTable"
    },
    var.public_route_table_tags
  )
  
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_eip" "nat" {
  domain = "vpc" 
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    },
    var.eip_tags
  )
   
}

resource "aws_nat_gateway" "nat" {
   allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[1].id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    },
    var.aws_nat_gateway_tags
  )

  depends_on = [ aws_internet_gateway.main ] 
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-Private-RoutTable"
    },
    var.private_route_table_tags
  )
  
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-Database-RoutTable"
    },
    var.database_route_table_tags
  )
  
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


resource "aws_route_table_association" "public" {
count = length(var.public_subnet_cidrs)
subnet_id = aws_subnet.public[count.index].id 
route_table_id = aws_route_table.public.id
}