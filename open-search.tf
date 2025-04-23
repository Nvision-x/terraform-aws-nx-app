# Define the security group for OpenSearch
resource "aws_security_group" "opensearch_sg" {
  count       = var.enable_opensearch ? 1 : 0
  name        = var.opensearch_security_group_name
  description = "Security group for OpenSearch"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
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


# OpenSearch module configuration
module "opensearch" {
  count  = var.enable_opensearch ? 1 : 0
  source = "terraform-aws-modules/opensearch/aws"

  # Domain
  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  advanced_security_options = {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true

    master_user_options = {
      master_user_name     = var.master_user_name
      master_user_password = var.opensearch_master_user_password
    }
  }

  cluster_config = {
    instance_count           = var.number_of_nodes
    dedicated_master_enabled = var.enable_masternodes
    instance_type            = var.opensearch_instance_type

    dedicated_master_count = var.enable_masternodes ? var.number_of_master_nodes : 0
    dedicated_master_type  = var.enable_masternodes ? var.opensearch_instance_type : ""

    zone_awareness_config = {
      availability_zone_count = 1
    }
    zone_awareness_enabled = false
  }

  domain_endpoint_options = {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  domain_name = var.domain_name

  ebs_options = {
    ebs_enabled = true
    volume_type = var.ebs_volume_type
    volume_size = var.ebs_volume_size
  }

  encrypt_at_rest = {
    enabled = true
  }

  engine_version = var.engine_version

  log_publishing_options = [
    { log_type = "INDEX_SLOW_LOGS" },
    { log_type = "SEARCH_SLOW_LOGS" },
  ]

  node_to_node_encryption = {
    enabled = true
  }

  vpc_options = {
    security_group_ids = [aws_security_group.opensearch_sg[0].id]
    subnet_ids         = [var.nfs_os_private_subnet_id]
  }

  tags = var.tags
}
