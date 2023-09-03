ec2_instances = {
    instance1 = {
      ami                           = "ami-053b0d53c279acc90"  
      instance_type                 = "t2.micro"      
      subnet_id                     = 0
      tags                          = {Name = "instance1"}
      associate_public_ip_address   = true
    },
    instance2 = {
      ami                           = "ami-053b0d53c279acc90"  
      instance_type                 = "t2.micro"      
      subnet_id                     = 1
      tags                          = {Name = "instance2"}
      associate_public_ip_address   = true
    }   
}
device_name = "/dev/sdf"

// pass it from jenkins
my_access_key = "unused"
my_secret_key = "unused"

# ami                           = "ami-0eb260c4d5475b901"  
# instance_type                 = "t2.micro"   
# vpc_security_group_ids        = ["sg-09f29aea973538c21"]
# associate_public_ip_address   = true