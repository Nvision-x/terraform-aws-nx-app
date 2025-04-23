module "nx" {
  # source = "git::https://github.com/Nvision-x/terraform-aws-nx.git?ref=v1.0.0"
  source = "../.."

  region          = var.region
  vpc_id          = var.vpc_id
  private_subnets = var.private_subnets
  vpc_cidr_block  = var.vpc_cidr_block

  cluster_name          = var.cluster_name
  cluster_version       = var.cluster_version
  instance_types        = var.instance_types
  node_group_1_name     = var.node_group_1_name
  node_group_2_name     = var.node_group_2_name
  node_group_2_min_size = var.node_group_2_min_size
  node_group_2_max_size = var.node_group_2_max_size

  enable_postgres        = var.enable_postgres
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  postgres_password      = var.postgres_password
  allocated_storage      = var.allocated_storage
  db_identifier          = var.db_identifier
  db_subnet_group_name   = var.db_subnet_group_name
  db_security_group_name = var.db_security_group_name
  postgres_version       = var.postgres_version

  enable_opensearch               = var.enable_opensearch
  master_user_name                = var.master_user_name
  opensearch_master_user_password = var.opensearch_master_user_password
  opensearch_instance_type        = var.opensearch_instance_type
  opensearch_security_group_name  = var.opensearch_security_group_name
  domain_name                     = var.domain_name
  ebs_volume_size                 = var.ebs_volume_size
  engine_version                  = var.engine_version
  enable_masternodes              = var.enable_masternodes
  number_of_master_nodes          = var.number_of_master_nodes
  number_of_nodes                 = var.number_of_nodes
  ebs_volume_type                 = var.ebs_volume_type

  enable_nfs               = var.enable_nfs
  nfs_os_private_subnet_id = var.nfs_os_private_subnet_id
  instance_type            = var.instance_type
  disk_size                = var.disk_size
  key_name                 = var.key_name
  ami                      = var.ami
  ec2_name                 = var.ec2_name
  security_group_name      = var.security_group_name
  existing_pem             = var.existing_pem

  tags = var.tags
}

module "eks_addons" {
  # source = "git::https://github.com//Nvision-x/terraform-aws-eks-addons.git?ref=v1.0.0"
  source            = "../../../terraform-aws-eks-addons"
  cluster_name      = module.nx.eks_cluster_name
  namespace         = "kube-system"
  region            = var.region
  vpc_id            = var.vpc_id
  oidc_provider_arn = module.nx.eks_oidc_provider_arn

  autoscaler_role_name          = var.autoscaler_role_name
  autoscaler_service_account    = var.autoscaler_service_account
  lb_controller_role_name       = var.lb_controller_role_name
  lb_controller_service_account = var.lb_controller_service_account

  providers = {
    kubectl = kubectl.eks
    helm    = helm.eks
  }
}

