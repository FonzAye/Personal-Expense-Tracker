resource "aws_db_subnet_group" "my_db" {
  name       = "db_subnet_group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "database" {
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  identifier           = var.identifier
  engine               = var.engine
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  publicly_accessible  = var.publicly_accessible
  skip_final_snapshot  = var.skip_final_snapshot
  port                 = var.port
  db_subnet_group_name = aws_db_subnet_group.my_db.name

  tags = var.tags
}

# Check if the secret exists
data "aws_secretsmanager_secret" "test" {
  count = var.create_secret ? 0 : 1
  name  = "test"
}

# Store Credentials in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_secret" {
  count = var.create_secret ? 1 : 0
  name = "test"
}

locals {
  db_secret_id = var.create_secret ? aws_secretsmanager_secret.db_secret[0].id : data.aws_secretsmanager_secret.test[0].id
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id     = local.db_secret_id
  secret_string = jsonencode({
    DB_USER = aws_db_instance.database.username
    DB_HOST = aws_db_instance.database.endpoint
    DB_NAME = aws_db_instance.database.db_name
    DB_PASS = aws_db_instance.database.password
    DB_PORT = aws_db_instance.database.port
  })
}