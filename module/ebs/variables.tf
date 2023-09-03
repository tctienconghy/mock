variable "avaiability_zones" {
  type    = set(string)
  default = ["eu-west-2a", "eu-west-2b"]
  description = "List of available_zone"
}

variable "ebs_size" {
    type = number
    default = 8
    description = "Size of the EBS volume in GB"
}

