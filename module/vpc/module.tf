resource "aws_vpc" "vpcs" {

  cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
 }  
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow sshl inbound traffic"
  vpc_id      = aws_vpc.vpcs.id

  ingress {
    description      = "TLS to VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP to VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_internet_gateway" "internet_gateway" {

  vpc_id = aws_vpc.vpcs.id
  tags = {
    Name = "Internet Gateway link to VPC: ${aws_vpc.vpcs.id}"
  }
}

resource "aws_subnet" "public_subnets" {

  for_each = var.subnet_cidr_mapping_az
  
  vpc_id                    = aws_vpc.vpcs.id
  cidr_block                = each.value.cidr
  availability_zone         = each.value.az
  map_public_ip_on_launch   =  true
}

resource "aws_route_table" "rtb_to_ps" {

  vpc_id = aws_vpc.vpcs.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = var.rtb_name
  }
}

resource "aws_route_table_association" "public_subnet_associate" {

 for_each       = aws_subnet.public_subnets
 
 subnet_id      = aws_subnet.public_subnets[each.key].id
 route_table_id = aws_route_table.rtb_to_ps.id
}