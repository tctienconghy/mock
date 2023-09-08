vpc_cidr = "10.0.0.0/16"
vpc_name = "TienTV_Terraform_VPC_DEV"
rtb_name = "TienTV_Route_Table_DEV"

subnet_cidr_mapping_az = {
  mapping1 = {
    cidr    = "10.0.4.0/24"
    az      = "us-east-1a" 
  }
}
