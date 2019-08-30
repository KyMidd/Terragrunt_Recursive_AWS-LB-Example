##
# Build seed components to permit remote state storage for terragrunt
##

# Init terraform
terraform {}

# Build an S3 bucket to store TF state
resource "aws_s3_bucket" "state_bucket" {
  bucket = "${var.name_of_s3_bucket}"

  # Tells AWS to encrypt the S3 bucket at rest by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
}

# Creates an IAM user for ADO to connect as - e.g., Authentication
resource "aws_iam_user" "ado_iam_user" {
  name = "${var.iam_user_name}"
  path = "/"

  tags = {
    BuiltBy = "Terraform"
  }
}

# Create IAM policy for the ADO IAM user
resource "aws_iam_policy" "ado_iam_policy" {
  name = "${var.aws_iam_policy_assume_name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAllPermissions",
      "Effect": "Allow",
      "Action": [
        "*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

# Attach IAM assume role to User
resource "aws_iam_user_policy_attachment" "iam_user_assume_attach" {
  user       = "${aws_iam_user.ado_iam_user.name}"
  policy_arn = "${aws_iam_policy.ado_iam_policy.arn}"
}
