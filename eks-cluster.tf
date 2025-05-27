module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns                         = {}
    eks-pod-identity-agent          = {}
    kube-proxy                      = {}
    vpc-cni                         = {}
    aws-ebs-csi-driver              = {}
    amazon-cloudwatch-observability = {}
  }

  enable_irsa = true # OIDC provider

  eks_managed_node_group_defaults = {
    disk_size = 50
  }

  eks_managed_node_groups = {
    node_group_1 = {
      name           = var.node_group_1_name
      instance_types = var.instance_types
      desired_size   = 1
      min_size       = 1
      max_size       = 10
    }
    node_group_2 = {
      name           = var.node_group_2_name
      instance_types = var.instance_types
      desired_size   = 2
      min_size       = var.node_group_2_min_size
      max_size       = var.node_group_2_max_size
      labels = {
        app = "nx-redis"
      }
    }
  }
}

resource "aws_iam_policy" "ebs_permissions" {
  name        = "ebs-permissions-policy-${var.cluster_name}"
  description = "Policy to allow EBS operations for EKS node group"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = local.ebs_permissions,
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_nodegroup_ebs" {
  for_each   = module.eks.eks_managed_node_groups
  policy_arn = aws_iam_policy.ebs_permissions.arn
  role       = each.value.iam_role_name
}

resource "aws_security_group_rule" "eks_control_plane_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.eks.cluster_security_group_id # EKS control plane security group
  cidr_blocks       = [var.vpc_cidr_block]

}
