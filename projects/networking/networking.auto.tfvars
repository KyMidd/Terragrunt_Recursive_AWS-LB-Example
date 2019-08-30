##
# Terraform variables file (those ending in .tfvars) are used to populate variables
# These variables are consumed by main.tf, and passed forward to modules
##

# CIDR Prefix for this vNet, e.g. "10.250."
#  Make sure to include the trailing period
vnet_cidr_prefix = "10.1."

# Region short code: e.g., Ue1, Uw1, etc.
region_short_code = "Ue1"

# Account short code, e.g. Ti, Ag, Au, etc.
account_name = "KylerDemo"
