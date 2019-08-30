# terragrunt.hcl
remote_state {
  backend = "s3"
  config = {
    bucket         = "s3-terragrunt-kyler-ue1-tfstate"
    key            = "projects/load_balancer/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "aws-locks-projects-load_balancer"
  }
}
