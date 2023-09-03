variable "ec2_instances" {
  type = map(object({
    ami                         = string
    instance_type               = string
    subnet_id                   = number
    tags                        = map(string)
    associate_public_ip_address = bool
  }))
}

variable "device_name" {
    type = string
    default = "/dev/sdf"
}

variable "my_access_key" {
    type = string
    default = ""
}
variable "my_secret_key" {
    type = string
    default = ""
}

# variable "vpc_cidr" {
#   type = string
#   default = "10.0.0.0/16"
# }

# variable "vpc_name" {
#   type = string
#   default = "TienTV_Terraform_VPC"
# }

# variable "rtb_name" {
#   type = string
#   default = "TienTV_Route_Table"
# }

# variable "subnet_cidr_mapping_az" {
#   type    = map(object({
#     cidr = string
#     az   = string
#   }))
#   # default = ["10.0.1.0/24", "10.0.2.0/24"]
# }