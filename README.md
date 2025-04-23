# terraform-aws-nx

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

| Name                          | Description                                         | Type           | Required |
|-------------------------------|-----------------------------------------------------|----------------|----------|
| region                        | AWS region to deploy resources                     | `string`       | ✅        |
| vpc_id                        | VPC ID to deploy infrastructure into               | `string`       | ✅        |
| private_subnets              | List of private subnet IDs                         | `list(string)` | ✅        |
| cluster_name                 | EKS cluster name                                    | `string`       | ✅        |
| cluster_version              | Kubernetes version for EKS                         | `string`       | ✅        |
| instance_types               | List of EC2 types for node groups                  | `list(string)` | ✅        |
| node_group_1_name            | Name of first node group                           | `string`       | ✅        |
| node_group_2_name            | Name of second node group                          | `string`       | ✅        |
| node_group_2_min_size        | Min size for second node group                     | `number`       | ✅        |
| node_group_2_max_size        | Max size for second node group                     | `number`       | ✅        |
| enable_postgres              | Flag to enable RDS PostgreSQL                      | `bool`         | ✅        |
| enable_opensearch            | Flag to enable OpenSearch                          | `bool`         | ✅        |
| enable_nfs                   | Flag to deploy EC2 for NFS                         | `bool`         | ✅        |
| ebs_permissions              | List of EBS-related IAM permissions                | `list(string)` | ✅        |
| ...                          | (See `variables.tf` for complete list)             |                |          |

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
