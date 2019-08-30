##
# variables.tf files create empty variables for use
# In main.tf files, variables will be populated by .tfvars files
# In modules, variables will be populated by main.tf module configuration
##

variable "vnet_cidr_prefix" {
  description = "Such as 10.55., used for building subnets, VPCs, etc."
}
variable "region_short_code" {
  description = "Such as Ue1, used for naming resources"
}
variable "account_name" {
  description = "Name of account for naming purposes"
}
