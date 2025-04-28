# terraform-aws-nx-app

Terraform module to provision the complete AWS infrastructure stack for the NX application. This includes:

- Amazon EKS cluster
- Amazon RDS (PostgreSQL)
- Amazon OpenSearch
- EC2 instance for NFS
- IAM roles, and other dependencies

---

## 📌 Requirements

| Name      | Version   |
|-----------|-----------|
| Terraform | >= 1.0    |
| AWS CLI   | >= 2.0    |

---

## 📦 Providers

| Name     | Source              |
|----------|---------------------|
| aws      | hashicorp/aws       |

---

## 📥 Inputs

## Inputs

| Name                           | Description                                         | Type            | Required |
|--------------------------------|-----------------------------------------------------|-----------------|----------|
| region                         | AWS region to deploy resources                     | `string`        | ✅        |
| vpc_id                         | VPC ID to deploy infrastructure into               | `string`        | ✅        |
| vpc_cidr_block                 | CIDR block of the VPC                               | `string`        | ✅        |
| private_subnets                | List of private subnet IDs                         | `list(string)`  | ✅        |
|||||
|**EKS Variables** ||||
| cluster_name                   | EKS cluster name                                   | `string`        | ✅        |
| cluster_version                | Kubernetes version for EKS                         | `string`        | ✅        |
| instance_types                 | List of EC2 types for EKS node groups               | `list(string)`  | ✅        |
| node_group_1_name              | Name of first managed node group                   | `string`        | ✅        |
| node_group_2_name              | Name of second managed node group                  | `string`        | ✅        |
| node_group_2_min_size          | Minimum number of nodes in node group 2            | `number`        | ❌ (default: 1) |
| node_group_2_max_size          | Maximum number of nodes in node group 2            | `number`        | ❌ (default: 10) |
|||||
|**Postgres Variables** ||||
| enable_postgres                | Flag to enable PostgreSQL resources                | `bool`          | ✅        |
| instance_class                 | RDS instance class                                 | `string`        | ✅        |
| db_name                        | Name of the database                               | `string`        | ✅        |
| username                       | Username for the database                          | `string`        | ✅        |
| postgres_password              | Password for the database                          | `string` (sensitive) | ❌ (default: null) |
| allocated_storage              | Allocated storage (in GB) for RDS                  | `string`        | ✅        |
| db_identifier                  | Identifier for RDS instance                        | `string`        | ✅        |
| db_subnet_group_name           | Name of the RDS subnet group                       | `string`        | ✅        |
| db_security_group_name         | Name of the RDS security group                     | `string`        | ✅        |
| postgres_version               | PostgreSQL version                                 | `string`        | ✅        |
| allow_major_version_upgrade    | Allow major version upgrades                      | `bool`          | ❌ (default: false) |
| apply_immediately              | Apply changes immediately                         | `bool`          | ❌ (default: false) |
| backup_window                  | Preferred backup window                           | `string`        | ❌ (default: "03:00-06:00") |
| copy_tags_to_snapshot          | Copy tags to snapshots                             | `bool`          | ❌ (default: true) |
| maintenance_window             | Preferred maintenance window                      | `string`        | ❌ (default: "mon:00:00-mon:03:00") |
| manage_master_user_password    | Manage master user password automatically         | `bool`          | ❌ (default: false) |
| parameter_group_name           | Parameter group name                              | `string`        | ❌ (default: null) |
| skip_final_snapshot            | Skip final snapshot before deletion               | `bool`          | ❌ (default: false) |
| backup_retention_period        | Number of days to retain backups                  | `number`        | ❌ (default: 7) |
| performance_insights_enabled   | Enable Performance Insights                       | `bool`          | ❌ (default: false) |
| postgres_ingress_rules         | List of ingress rules for PostgreSQL              | `list(object)`  | ❌ (default: []) |
|||||
|**OpenSearch Variables** ||||
| enable_opensearch              | Flag to enable OpenSearch resources               | `bool`          | ✅        |
| master_user_name               | OpenSearch admin username                         | `string`        | ✅        |
| opensearch_master_user_password| OpenSearch admin password                         | `string` (sensitive) | ❌ (default: null) |
| opensearch_instance_type       | Instance type for OpenSearch                      | `string`        | ✅        |
| opensearch_security_group_name | OpenSearch security group name                    | `string`        | ✅        |
| opensearch_security_group_description | Description for OpenSearch security group | `string` | ❌ (default: "Managed by Terraform") |
| domain_name                    | OpenSearch domain name                            | `string`        | ✅        |
| ebs_volume_size                | EBS volume size for OpenSearch                    | `string`        | ✅        |
| engine_version                 | OpenSearch engine version                         | `string`        | ✅        |
| enable_masternodes             | Enable dedicated master nodes                    | `bool`          | ✅        |
| number_of_master_nodes         | Number of dedicated master nodes                 | `number`        | ✅        |
| number_of_nodes                | Number of data nodes                             | `number`        | ✅        |
| ebs_volume_type                | EBS volume type for OpenSearch                    | `string`        | ❌ (default: "gp3") |
| opensearch_ingress_rules       | List of ingress rules for OpenSearch              | `list(object)`  | ❌ (default: []) |
| zone_awareness_enabled         | Enable zone awareness for OpenSearch             | `bool`          | ❌ (default: false) |
| availability_zone_count        | Number of AZs if zone awareness enabled          | `number`        | ❌ (default: 1) |
| opensearch_subnet_ids          | List of private subnets for OpenSearch            | `list(string)`  | ✅        |
| opensearch_log_publishing_options | List of log publishing options                 | `list(object)`  | ❌ (default: []) |
| auto_software_update_enabled   | Enable automatic software updates for OpenSearch | `bool`          | ❌ (default: false) |
|||||
|**NFS Variables** ||||
| enable_nfs                     | Flag to deploy EC2 for NFS server                | `bool`          | ✅        |
| nfs_ingress_rules              | List of ingress rules for nfs                    | `list(object)`  | ❌ (default: []) |
| nfs_private_subnet_id          | Subnet ID for NFS EC2 instance                    | `string`        | ✅        |
| nfs_security_group_description | Description for NFS security group                | `string`        | ❌ (default: "Allow SSH and NFS access") |
| key_name                       | Key pair name for EC2 instance                    | `string`        | ✅        |
| instance_type                  | Instance type for EC2 instance                    | `string`        | ✅        |
| disk_size                      | Size of root disk for EC2 instance (in GB)         | `number`        | ❌ (default: 100) |
| ami                            | AMI ID for EC2 instance                          | `string`        | ✅        |
| ec2_name                       | Name tag for EC2 instance                        | `string`        | ✅        |
| security_group_name            | Security group name for EC2                      | `string`        | ✅        |
| existing_pem                   | Existing PEM key if any                          | `string`        | ❌ (default: "") |
| tags                           | Tags to apply to all resources                   | `map(string)`   | ❌ (default: `{ Project = "nx-app" }`) |


---

## 📤 Outputs

| Name                    | Description                                  |
|-------------------------|----------------------------------------------|
| eks_cluster_endpoint    | EKS API server endpoint                      |
| eks_cluster_ca          | EKS cluster certificate authority (base64)   |
| eks_cluster_name        | EKS cluster name                             |
| eks_oidc_provider_arn   | OIDC provider ARN for IRSA                   |
| vpc_id                  | VPC ID used                                  |

---

## 🚀 Example

```hcl
module "nx" {
  source = "git::https://github.com/Nvision-x/terraform-aws-nx.git?ref=v1.0.0"
  cluster_name = "nx-cluster"
  region       = "us-east-2"
  ...
}
