resource "aws_ebs_volume" "ebs_volumes" {
    for_each = var.avaiability_zones

    availability_zone   = each.value
    size                = var.ebs_size 
}