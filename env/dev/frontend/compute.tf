module "ec2_instances" {
    source = "../../../module/ec2"
    ec2_instances = var.ec2_instances
}


resource "null_resource" "ansible_inventory" {
  triggers = {
    mytrigger = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo '{
        "ec2": {
          "hosts": {
            ${join(",", [for instance in module.ec2_instances.list_ec2_ip : "${instance}"])},
          }
        }
      }' > /path/to/ansible_inventory.json
    EOT
  }
}
