ec2_instances = {
    instance1 = {
      ami                           = "ami-053b0d53c279acc90"  
      instance_type                 = "t2.micro"      
      subnet_id                     = 0
      tags                          = {Name = "dev_instance1"}
      associate_public_ip_address   = true
    }
}
device_name = "/dev/sdf"


// pass it from jenkins

# ami                           = "ami-0eb260c4d5475b901"  
# instance_type                 = "t2.micro"   
# vpc_security_group_ids        = ["sg-09f29aea973538c21"]
# associate_public_ip_address   = true
