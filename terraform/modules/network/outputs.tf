output "subnet_id_public" {
  value = aws_subnet.public.id
}

output "subnet_id_private" {
  value = aws_subnet.private.id
}

output "subnet_id_db" {
  value = aws_subnet.db.id
}

output "vpc_security_group_ids" {
  value = aws_security_group.instances.id
}