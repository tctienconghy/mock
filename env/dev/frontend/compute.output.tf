# output "ec2_instance_details" {
#   value = {
#     for instance_key, instance_value in aws_instance.ec2_instances :
#     instance_key => {
#       instance_id    = instance_value.id
#       public_ip      = instance_value.public_ip
#       private_ip     = instance_value.private_ip
#     }
#   }
# }
