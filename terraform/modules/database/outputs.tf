output "db_name" {
  value = aws_db_instance.database.db_name
}

output "db_user" {
  value = aws_db_instance.database.endpoint
}