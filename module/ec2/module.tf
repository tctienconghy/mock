module "vpcs" {
    source = "../../module/vpc"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "TienTV_Terraform_VPC"
    rtb_name = "TienTV_Terraform_Route_Table"
    subnet_cidr_mapping_az = {
        mapping1 = {
            cidr    = "10.0.3.0/24"
            az      = "us-east-1a" 
        }
        mapping2 = {
            cidr    = "10.0.4.0/24"
            az      = "us-east-1b"
        }
    }
}


module "ebs" {
  source = "../../module/ebs"
  ebs_size = 8 
  avaiability_zones = ["us-east-1a", "us-east-1b"]

}

resource "aws_instance" "ec2_instances" {
    for_each = var.ec2_instances

    ami                         = each.value.ami
    instance_type               = each.value.instance_type
    subnet_id                   = module.vpcs.public_subnet_ids[each.value.subnet_id]
    vpc_security_group_ids      = [module.vpcs.security_group_id]
    tags                        = each.value.tags
    associate_public_ip_address = each.value.associate_public_ip_address
    key_name                    = "tien_trinh"
}


resource "aws_volume_attachment" "ebs_attachment" {
    for_each = {
        for az, ebs_id in module.ebs.ebs_volume_details :
        az => {
        ebs_id           = ebs_id
        ec2_id           = lookup([for ec2 in aws_instance.ec2_instances : ec2 if ec2.availability_zone == az][0], "id", null)
        }
    }

    device_name     = var.device_name
    instance_id     = each.value.ec2_id
    volume_id       = each.value.ebs_id
}
