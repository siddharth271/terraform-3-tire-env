output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet" {
  value = aws_subnet.private_subnet.id
}

output "eip-nat" {
  value = aws_eip.nat_elastic_ip.id
}

output "ngw" {
  value = aws_nat_gateway.nat-gateway.id
}

output "public-association" {
  value = aws_route_table_association.private-subnet-association.id
}

output "private-association" {
  value = aws_route_table_association.public_subnet_association.id
}

output "route_table_public" {
  value = aws_route_table.public-route.id
}

output "route_table_private" {
  value = aws_route_table.private-routes.id
}