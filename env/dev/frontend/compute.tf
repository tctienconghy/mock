module "ec2_instances" {
    source = "../../../module/ec2"
    ec2_instances = var.ec2_instances
}

locals {
  list_ec2_ip = module.ec2_instances.list_ec2_ip
}

resource "null_resource" "ansible_inventory" {
  triggers = {
    list_ec2_ip = join(",", local.list_ec2_ip)
  }
  for_each = local.list_ec2_ip

  provisioner "local-exec" {
    command = <<-EOF
      echo "[dev]" > dev_dynamic_inventory
      {% for ip in local.list_ec2_ip %}
      echo "${each.value} ansible_user=\"ubuntu\"" >> dev_dynamic_inventory
      {% endfor %}
    EOF
  }
}
