module "nx" {
  source = "git::https://github.com/Nvision-x/terraform-aws-nx-app.git"
  # source = "../.."

  # --------------------- Global/Provider ---------------------
  region          = var.region
  vpc_cidr_block  = var.vpc_cidr_block
  vpc_id          = var.vpc_id
  private_subnets = var.private_subnets
  tags            = var.tags

  # --------------------- EKS ---------------------
  cluster_name          = var.cluster_name
  cluster_version       = var.cluster_version
  instance_types        = var.instance_types
  node_group_1_name     = var.node_group_1_name
  node_group_2_max_size = var.node_group_2_max_size
  node_group_2_min_size = var.node_group_2_min_size
  node_group_2_name     = var.node_group_2_name

  # --------------------- PostgreSQL ---------------------
  allocated_storage             = var.allocated_storage
  allow_major_version_upgrade   = var.allow_major_version_upgrade
  apply_immediately             = var.apply_immediately
  backup_retention_period       = var.backup_retention_period
  backup_window                 = var.backup_window
  copy_tags_to_snapshot         = var.copy_tags_to_snapshot
  db_identifier                 = var.db_identifier
  db_name                       = var.db_name
  db_security_group_description = "Allow PostgreSQL access"
  db_security_group_name        = var.db_security_group_name
  db_subnet_group_name          = var.db_subnet_group_name
  enable_postgres               = var.enable_postgres
  instance_class                = var.instance_class
  maintenance_window            = var.maintenance_window
  manage_master_user_password   = var.manage_master_user_password
  parameter_group_name          = var.parameter_group_name
  performance_insights_enabled  = var.performance_insights_enabled
  postgres_password             = var.postgres_password
  postgres_version              = var.postgres_version
  skip_final_snapshot           = var.skip_final_snapshot
  subnet_group_description      = var.subnet_group_description
  username                      = var.username

  # --------------------- OpenSearch ---------------------

  domain_name                           = var.domain_name
  ebs_volume_size                       = var.ebs_volume_size
  ebs_volume_type                       = var.ebs_volume_type
  enable_masternodes                    = var.enable_masternodes
  enable_opensearch                     = var.enable_opensearch
  engine_version                        = var.engine_version
  master_user_name                      = var.master_user_name
  number_of_master_nodes                = var.number_of_master_nodes
  number_of_nodes                       = var.number_of_nodes
  opensearch_instance_type              = var.opensearch_instance_type
  opensearch_master_user_password       = var.opensearch_master_user_password
  opensearch_security_group_description = "os-sg"
  opensearch_security_group_name        = var.opensearch_security_group_name
  opensearch_subnet_ids                 = var.opensearch_subnet_ids

  # --------------------- NFS ---------------------
  ami                   = var.ami
  disk_size             = var.disk_size
  ec2_name              = var.ec2_name
  enable_nfs            = var.enable_nfs
  existing_pem          = var.existing_pem
  instance_type         = var.instance_type
  key_name              = var.key_name
  nfs_private_subnet_id = var.nfs_private_subnet_id
  security_group_name   = var.security_group_name
}

module "eks_addons" {
  source = "git::https://github.com/Nvision-x/terraform-aws-eks-addons.git?ref=v1.0.0"
  # source = "../../../terraform-aws-eks-addons"

  # --------------------- EKS Addons ---------------------
  autoscaler_role_name          = var.autoscaler_role_name
  autoscaler_service_account    = var.autoscaler_service_account
  lb_controller_role_name       = var.lb_controller_role_name
  lb_controller_service_account = var.lb_controller_service_account

  # --------------------- EKS Cluster ---------------------
  cluster_name      = module.nx.eks_cluster_name
  oidc_provider_arn = module.nx.eks_oidc_provider_arn
  namespace         = "kube-system"
  region            = var.region
  vpc_id            = var.vpc_id

  # --------------------- Providers ---------------------
  providers = {
    helm    = helm.eks
    kubectl = kubectl.eks
  }
}
