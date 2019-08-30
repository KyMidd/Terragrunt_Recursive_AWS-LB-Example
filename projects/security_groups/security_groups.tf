# Init terraform
terraform {
  backend "s3" {}
}

# Map the networking remote state to find out subnet outputs
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "s3-terragrunt-kyler-ue1-tfstate"
    key    = "projects/networking/terraform.tfstate"
    region = "us-east-1"
  }
}

# Build security group for internal
resource "aws_security_group" "internal_server_sg" {
  name   = "internal_server_sg"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc1
}

# Permit traffic inbound - internal SG
resource "aws_security_group_rule" "internal_allow_all_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internal_server_sg.id
}

# Permit traffic outbound - internal SG
resource "aws_security_group_rule" "internal_allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internal_server_sg.id
}

# Build security group for load balancer (external)
resource "aws_security_group" "load_balancer_sg" {
  name   = "load_balancer_sg"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc1
}

# Permit traffic inbound - load balancer SG
resource "aws_security_group_rule" "load_balancer_allow_all_inbound" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer_sg.id
}

# Permit traffic outbound - load balancer SG
resource "aws_security_group_rule" "load_balancer_allow_non_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["127.0.0.1/32"]
  security_group_id = aws_security_group.load_balancer_sg.id
}
