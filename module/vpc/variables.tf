variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type = string
  default = "TienTV_Terraform_VPC"
}

variable "rtb_name" {
  type = string
  default = "TienTV_Route_Table"
}

variable "subnet_cidr_mapping_az" {
  type    = map(object({
    cidr = string
    az   = string
  }))
  # default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# variable "avaiability_zones" {
#   type    = list(string)
#   default = ["eu-west-2a", "eu-west-2b"]
# }