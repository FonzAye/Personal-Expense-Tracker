resource "aws_db_instance" "default" {
  allocated_storage    = 20
  db_name              = "mydb"
  identifier           = "petdb"
  engine               = "postgres"
#   engine_version       = "8.0"
  instance_class       = "db.t4g.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.postgres16"
  publicly_accessible  = true
  skip_final_snapshot  = true
  port = 5432

  tags = {
    Name = "terraform_db"
  }
}