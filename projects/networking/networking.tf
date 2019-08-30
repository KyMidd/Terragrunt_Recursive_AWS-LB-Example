# Init terraform
terraform {
  backend "s3" {}
}

# Build the VPC
resource "aws_vpc" "vpc1" {
  cidr_block           = "${var.vnet_cidr_prefix}0.0/16"
  enable_dns_hostnames = "false"
  enable_dns_support   = "true"

  tags = {
    Name      = "${var.region_short_code}${var.account_name}Vpc1"
    Terraform = "true"
  }
}

# Build IGW for external subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.region_short_code}${var.account_name}Igw1"
  }
}

# Build route table for external
resource "aws_route_table" "external_rt" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.region_short_code}${var.account_name}ExternalRt"
  }
}

# Create default route to IGW
resource "aws_route" "dia_igw_default_route" {
  route_table_id         = aws_route_table.external_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = ["aws_route_table.external_rt"]
}

# build external subnet 1
resource "aws_subnet" "external_subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "${var.vnet_cidr_prefix}10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.region_short_code}${var.account_name}ExternalSubnet1"
  }
}

# Associate external subnet1 to external route table
resource "aws_route_table_association" "external_subnet1_rt_association" {
  subnet_id      = aws_subnet.external_subnet1.id
  route_table_id = aws_route_table.external_rt.id
}

# Build secondary external subnet
resource "aws_subnet" "external_subnet2" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "${var.vnet_cidr_prefix}11.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.region_short_code}${var.account_name}ExternalSubnet2"
  }
}

# Associate external subnet2 to external route table
resource "aws_route_table_association" "external_subnet2_rt_association" {
  subnet_id      = aws_subnet.external_subnet2.id
  route_table_id = aws_route_table.external_rt.id
}

# Create public IP for NAT gateway
resource "aws_eip" "eip_ngw" {
  vpc = "true"
}

# Build Nat gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip_ngw.id
  subnet_id     = aws_subnet.external_subnet1.id

  tags = {
    Name = "${var.region_short_code}${var.account_name}NatGateway"
  }
}

# Build default route table1
resource "aws_route_table" "nat_route_table" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.region_short_code}${var.account_name}NatRouteTable1"
  }
}

# Create default route to NAT gateway
resource "aws_route" "nat_route_table_default_route" {
  route_table_id         = aws_route_table.nat_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
  depends_on             = ["aws_route_table.nat_route_table"]
}

# Build internal subnets
resource "aws_subnet" "internal_subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "${var.vnet_cidr_prefix}0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.region_short_code}${var.account_name}InternalSubnet1"
  }
}

# Associate internal subnet1 to external route table
resource "aws_route_table_association" "internal_subnet1_rt_association" {
  subnet_id      = aws_subnet.internal_subnet1.id
  route_table_id = aws_route_table.nat_route_table.id
}

resource "aws_subnet" "internal_subnet2" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "${var.vnet_cidr_prefix}1.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.region_short_code}${var.account_name}InternalSubnet2"
  }
}

# Associate internal subnet1 to external route table
resource "aws_route_table_association" "internal_subnet2_rt_association" {
  subnet_id      = aws_subnet.internal_subnet2.id
  route_table_id = aws_route_table.nat_route_table.id
}
