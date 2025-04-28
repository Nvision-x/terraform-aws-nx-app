# ------------------------ Global/Provider Config ------------------------

variable "region" {
  description = "The AWS region to deploy resources into"
  type        = string
}

# ----------------------------- Networking -------------------------------

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnets in the VPC"
  type        = list(string)
}

# ----------------------------- EKS --------------------------------------

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "instance_types" {
  description = "List of EC2 instance types for the EKS node groups"
  type        = list(string)
}

variable "node_group_1_name" {
  description = "Name of the first managed node group"
  type        = string
}

variable "node_group_2_name" {
  description = "Name of the second managed node group"
  type        = string
}

variable "node_group_2_min_size" {
  description = "Minimum number of nodes in node group 2"
  type        = number
  default     = 1
}

variable "node_group_2_max_size" {
  description = "Maximum number of nodes in node group 2"
  type        = number
  default     = 10
}

# ----------------------------- NFS --------------------------------------

variable "enable_nfs" {
  description = "Flag to control EC2-related resource creation"
  type        = bool
}

variable "nfs_os_private_subnet_id" {
  description = "Private subnet ID where the EC2 instance will be deployed"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "disk_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 100
}

variable "ami" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "ec2_name" {
  description = "The Name tag for the EC2 instance"
  type        = string
}

variable "security_group_name" {
  description = "The name of the security group for the EC2 instance"
  type        = string
}

variable "existing_pem" {
  description = "Existing PEM key to use, if provided"
  type        = string
  default     = ""
}

# ----------------------------- PostgreSQL -------------------------------

variable "subnet_group_description" {
  description = "Description for the RDS subnet group"
  type        = string
  default     = "Managed by Terraform"
}

variable "db_security_group_description" {
  description = "Description for the RDS security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "enable_postgres" {
  description = "Flag to enable/disable PostgreSQL and related resources"
  type        = bool
}

variable "instance_class" {
  description = "The class of the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "username" {
  description = "The username for the database"
  type        = string
}

variable "postgres_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = null
}

variable "allocated_storage" {
  description = "The size of the database storage in GB"
  type        = string
}

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "db_subnet_group_name" {
  description = "The name of the database subnet group"
  type        = string
}

variable "db_security_group_name" {
  description = "The name of the database security group"
  type        = string
}

variable "postgres_version" {
  description = "PostgreSQL version for the RDS instance"
  type        = string
}

variable "allow_major_version_upgrade" {
  description = "Whether to allow major version upgrades during updates"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Whether to apply changes immediately or during the next maintenance window"
  type        = bool
  default     = false
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-06:00"
}

variable "copy_tags_to_snapshot" {
  description = "Whether to copy tags to snapshots"
  type        = bool
  default     = true
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "mon:00:00-mon:03:00"
}

variable "manage_master_user_password" {
  description = "Whether the master user password is managed by RDS automatically"
  type        = bool
  default     = false
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot before deleting the instance"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for"
  type        = number
  default     = 7
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "postgres_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}


# --------------------------- OpenSearch ---------------------------------

variable "enable_opensearch" {
  description = "Flag to enable or disable OpenSearch and related resources"
  type        = bool
}

variable "master_user_name" {
  description = "The username for the OpenSearch admin"
  type        = string
}

variable "opensearch_master_user_password" {
  description = "The password for the OpenSearch admin"
  type        = string
  sensitive   = true
  default     = null
}

variable "opensearch_instance_type" {
  description = "The type of instance for the OpenSearch cluster"
  type        = string
}

variable "opensearch_security_group_name" {
  description = "The name of the security group for OpenSearch"
  type        = string
}
variable "opensearch_security_group_description" {
  description = "Description for the OpenSearch security group"
  type        = string
  default     = "Managed by Terraform"
}

variable "domain_name" {
  description = "The domain name for the OpenSearch cluster"
  type        = string
}

variable "ebs_volume_size" {
  description = "The size of the EBS volume in GB for OpenSearch"
  type        = string
}

variable "engine_version" {
  description = "The version of the OpenSearch engine"
  type        = string
}

variable "enable_masternodes" {
  description = "Enable master nodes for OpenSearch"
  type        = bool
}

variable "number_of_master_nodes" {
  description = "Number of master nodes for OpenSearch"
  type        = number
}

variable "number_of_nodes" {
  description = "Number of data nodes for OpenSearch"
  type        = number
}

variable "ebs_volume_type" {
  description = "EBS volume type for OpenSearch nodes"
  type        = string
  default     = "gp3"
}

variable "opensearch_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "zone_awareness_enabled" {
  description = "Whether to enable zone awareness for OpenSearch cluster"
  type        = bool
  default     = false
}

variable "availability_zone_count" {
  description = "Number of Availability Zones to use if zone awareness is enabled"
  type        = number
  default     = 1
}

variable "opensearch_subnet_ids" {
  description = "List of private subnet IDs for OpenSearch"
  type        = list(string)
}

variable "opensearch_log_publishing_options" {
  description = "List of log publishing options for OpenSearch"
  type = list(object({
    log_type = string
  }))
  default = []
}



# --------------------- Tag -----------------------------

variable "tags" {
  description = "A map of tags to assign to all applicable resources"
  type        = map(string)
  default = {
    Project = "nx-app"
  }
}

