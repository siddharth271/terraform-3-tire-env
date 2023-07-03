#creating vpc

resource "aws_vpc" "vpc" {
  count = var.use_existing_vpc == "false" ? (var.enabled ? 1: 0) : 0
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-test"
  }
}

#private subnet
resource "aws_subnet" "public_subnet" {
  count = var.use_existing_vpc == "false" ? (var.enabled && length(var.public_cidr) > 0 ? length(var.public_cidr) : 0) : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

#private subnet
resource "aws_subnet" "private_subnet" {
  count = var.use_existing_vpc == "false" ? (var.enabled && length(var.private_cidr) > 0 ? length(var.private_cidr) : 0) : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "private_subnet"
  }
}

#internet gateway
resource "aws_internet_gateway" "igw" {
  count = var.use_existing_vpc == "false" ? (var.enabled && length(var.public_cidr) > 0 ? 1 : 0) : 0
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

#public routes
resource "aws_route_table" "public-route" {
  count = var.use_existing_vpc == "false" ? (var.enabled && length(var.private_cidr) > 0 ? length(var.private_cidr) : 0) : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route"
  }
}

#public subnet association
resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.public-route
  subnet_id = aws_subnet.public_subnet.id
}

#elastic ip for Nat gateway

resource "aws_eip" "nat_elastic_ip" {
  count = var.use_existing_vpc == "false" ? (var.enabled ? 1 : 0) : 0
  tags = {
    Name = "nat_elastic_ip"
  }
}

#nat gateway
resource "aws_nat_gateway" "nat-gateway" {
  count = var.use_existing_vpc == "false" ? (var.enabled ? 1 : 0) : 0
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_elastic_ip.id
  tags = {
    Name = "nat-gateway"
  }
}

# private routes
resource "aws_route_table" "private-routes" {
  count          = var.use_existing_vpc == "false" ? (var.enabled && length(var.private_cidr) > 0 ? length(var.private_cidr) : 0) : 0
  vpc_id = aws_vpc.vpc[0].id
  route {
    cidr_block     = var.private_cidr
    nat_gateway_id = element(aws_nat_gateway.nat-gateway.id)
  }
  tags = {
    Name = "private-route"
  }
}

#private route association
resource "aws_route_table_association" "private-subnet-association" {
  count          = var.use_existing_vpc == "false" ? (var.enabled && length(var.private_cidr) > 0 ? length(var.private_cidr) : 0) : 0
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.public-route.id
}
