##
# Define variables for Azure DevOps Seed Module
##

variable "name_of_s3_bucket" {
  default = "s3-terragrunt-kyler-ue1-tfstate"
}
variable "iam_user_name" {
  default = "AzureDevOpsTerragruntIamUser"
}
variable "ado_iam_role_name" {
  default = "AzureDevOpsTerragruntIamRole"
}
variable "aws_iam_policy_permits_name" {
  default = "AzureDevOpsTerragruntIamPolicyPermits"
}
variable "aws_iam_policy_assume_name" {
  default = "AzureDevOpsTerragruntIamPolicyAssume"
}
