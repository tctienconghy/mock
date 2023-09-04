# output "ec2_instance_details" {
#   value = [
#     for instance in aws_instance.ec2_instances :
#     {
#       instance_id       = instance.id
#       availability_zone =  instance.availability_zone
#     }
#   ]
# }


output "list_ec2_ip" {
  value = { 
    for instance in aws_instance.ec2_instances : instance.id => instance.public_ip
  }
}
