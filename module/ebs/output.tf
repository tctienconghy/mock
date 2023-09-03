locals {
  ebs_to_az_map = {
    for vol in aws_ebs_volume.ebs_volumes :
    vol.availability_zone => vol.id
  }
}

output "ebs_volume_details" {
  value = local.ebs_to_az_map
}
