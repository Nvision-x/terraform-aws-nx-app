# DB Subnet Group
resource "aws_db_subnet_group" "private" {
  count      = var.enable_postgres ? 1 : 0
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnets
}

# Security Group for PostgreSQL
resource "aws_security_group" "db_sg" {
  count       = var.enable_postgres ? 1 : 0
  name        = var.db_security_group_name
  description = "Allow PostgreSQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

# RDS PostgreSQL Instance
module "postgresql" {
  count  = var.enable_postgres ? 1 : 0
  source = "terraform-aws-modules/rds/aws"

  identifier = var.db_identifier
  engine     = "postgres"
  family     = "postgres${var.postgres_version}"

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  storage_type          = "gp2"
  max_allocated_storage = 0
  multi_az              = false
  publicly_accessible   = false
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.username
  password = var.postgres_password
  port     = 5432

  vpc_security_group_ids = [aws_security_group.db_sg[0].id]
  db_subnet_group_name   = aws_db_subnet_group.private[0].name

  maintenance_window           = "Mon:00:00-Mon:03:00"
  backup_window                = "03:00-06:00"
  backup_retention_period      = 7
  performance_insights_enabled = false
  tags                         = var.tags
}
