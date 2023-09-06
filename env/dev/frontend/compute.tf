module "ec2_instances" {
    source = "../../../module/ec2"
    ec2_instances = var.ec2_instances
}

locals {
  list_ec2_ip = module.ec2_instances.list_ec2_ip
}

resource "null_resource" "ansible_inventory" {
  triggers = {
    myTrigger = timestamp()
  }

  count = length(local.list_ec2_ip)

  provisioner "local-exec" {
    command = <<-EOF
      echo "[ec2_hosts]" > /Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/dev_dynamic_inventory
      echo "${local.list_ec2_ip[count.index]} ansible_user=\"ubuntu\" ansible_ssh_extra_args='-o StrictHostKeyChecking=no'" >> /Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/dev_dynamic_inventory
    EOF
  }
  depends_on = [ module.ec2_instances.list_ec2_ip ]
}
