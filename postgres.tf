# DB Subnet Group
resource "aws_db_subnet_group" "private" {
  count       = var.enable_postgres ? 1 : 0
  name        = var.db_subnet_group_name
  subnet_ids  = var.private_subnets
  description = var.subnet_group_description
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
  count      = var.enable_postgres ? 1 : 0
  source     = "terraform-aws-modules/rds/aws"
  version    = "6.12.0"
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

  backup_retention_period      = var.backup_retention_period
  performance_insights_enabled = var.performance_insights_enabled
  allow_major_version_upgrade  = var.allow_major_version_upgrade
  apply_immediately            = var.apply_immediately
  backup_window                = var.backup_window
  copy_tags_to_snapshot        = var.copy_tags_to_snapshot
  maintenance_window           = var.maintenance_window
  manage_master_user_password  = var.manage_master_user_password
  parameter_group_name         = var.parameter_group_name
  skip_final_snapshot          = var.skip_final_snapshot
  create_db_parameter_group    = false
  tags                         = var.tags
}
