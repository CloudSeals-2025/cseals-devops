output "project_vpc_id" {
  value = aws_vpc.project_vpc_us_east_1.id
}

output "project_public_subnets" {
  value = aws_subnet.project_public_subnets.*.id
}

output "public_subnet_cidr_block" {
  value = aws_subnet.project_public_subnets.*.cidr_block
}