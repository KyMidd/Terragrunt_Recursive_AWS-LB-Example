output "vpc1" {
  value = aws_vpc.vpc1.id
}
output "internal_subnet1" {
  value = aws_subnet.internal_subnet1.id
}
output "internal_subnet2" {
  value = aws_subnet.internal_subnet2.id
}
output "external_subnet1" {
  value = aws_subnet.external_subnet1.id
}
output "external_subnet2" {
  value = aws_subnet.external_subnet2.id
}
