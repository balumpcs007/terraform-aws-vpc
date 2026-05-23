resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    var.vpc_tags,
    local.comman_tags,
    {
        Name = local.comman_name_suffix
    }
  )
}

# IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.igw_tags,
    local.comman_tags,
    {
        Name = local.comman_name_suffix
    }
  )
}

# Public Subnet
resource "aws_subnet" "public" {
    count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = local.aws_availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.public_subnet_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-public-${local.aws_availability_zones[count.index]}"
    }
  )
}

# Private Subnet
resource "aws_subnet" "private" {
    count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_cidr_block[count.index]
  availability_zone = local.aws_availability_zones[count.index]

  tags = merge(
    var.private_subnet_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-private-${local.aws_availability_zones[count.index]}"
    }
  )
}

# Database Subnet
resource "aws_subnet" "database" {
    count = length(var.database_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_cidr_block[count.index]
  availability_zone = local.aws_availability_zones[count.index]

  tags = merge(
    var.database_subnet_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-database-${local.aws_availability_zones[count.index]}"
    }
  )
}

# Public Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.public_route_table_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-public"
    }
  )
}

# Private Route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.private_route_table_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-private"
    }
  )
}

# Database Route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.database_route_table_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-database"
    }
  )
}

# Public Route
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

# EIP
resource "aws_eip" "nat" {
  domain   = "vpc"
   tags = merge(
    var.eip_tags,
    local.comman_tags,
    {
        Name = "${local.comman_name_suffix}-nat"
    }
  )
}

# Nategate way
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.nat_gateway_tags,
    local.comman_tags,
    {
      Name = "${local.comman_name_suffix}"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# Private Route
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


# Database Route
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

# Public subnet association
resource "aws_route_table_association" "public" {
    count = length(var.public_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private subnet association
resource "aws_route_table_association" "private" {
    count = length(var.private_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Database subnet association
resource "aws_route_table_association" "database" {
    count = length(var.database_cidr_block)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}