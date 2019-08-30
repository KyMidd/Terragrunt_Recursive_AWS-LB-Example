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

# Deploy an AWS instance called "server" with it
resource "aws_instance" "server1" {
  ami           = "ami-0378588b4ae11ec24"
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networking.outputs.internal_subnet1

  tags = {
    Name      = "${var.region}${var.account}InternalServer1"
    Terraform = "true"
  }
}

# Build second server in different
resource "aws_instance" "server2" {
  ami           = "ami-0378588b4ae11ec24"
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.networking.outputs.internal_subnet2

  tags = {
    Name      = "${var.region}${var.account}InternalServer2"
    Terraform = "true"
  }
}
