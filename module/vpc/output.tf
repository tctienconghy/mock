output "public_subnet_ids" {
  value = [for s in aws_subnet.public_subnets : s.id]
}

output "security_group_id" {
  value = aws_security_group.allow_ssh.id
}
