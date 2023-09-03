module "ec2_instances" {
    source = "../../../module/ec2"
    ec2_instances = var.ec2_instances
}
