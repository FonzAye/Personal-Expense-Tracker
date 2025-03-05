variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "mydb"
}

variable "identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "petdb"
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "postgres"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t4g.micro"
}

variable "username" {
  description = "The master username for the database"
  type        = string
  default     = "foo"
}

variable "password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
  default     = "foobarbaz"
}

variable "parameter_group_name" {
  description = "The name of the DB parameter group to associate with the instance"
  type        = string
  default     = "default.postgres16"
}

variable "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the DB instance"
  type        = bool
  default     = true
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 5432
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default = {
    Name = "terraform_db"
  }
}

variable "create_secret" {
  description = "Create a new secret?"
  type    = bool
  }

variable "subnet_ids" {
  description = "Subnet IDs for subnet group"
  type = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type = list(string)
}