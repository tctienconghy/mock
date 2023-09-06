module "ec2_instances" {
    source = "../../../module/ec2"
    ec2_instances = var.ec2_instances
}

locals {
  list_ec2_ip = module.ec2_instances.list_ec2_ip
}

resource "null_resource" "ansible_inventory" {
  count = length(local.list_ec2_ip)

  provisioner "local-exec" {
    command = <<-EOF
      echo "[ec2_hosts]" > dev_dynamic_inventory
      echo "${local.list_ec2_ip[count.index]} ansible_ssh_extra_args='-o StrictHostKeyChecking=no'" >> dev_dynamic_inventory
    EOF
  }
  depends_on = [ module.ec2_instances.list_ec2_ip ]
}
