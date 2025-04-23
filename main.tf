locals {
  ebs_permissions = [
    "ec2:CreateVolume",
    "ec2:DeleteVolume",
    "ec2:AttachVolume",
    "ec2:DetachVolume",
    "ec2:ModifyVolume",
    "ec2:DescribeInstances",
    "ec2:DescribeVolumes",
    "ec2:DescribeVolumeStatus",
    "ec2:DescribeSnapshots",
    "ec2:DescribeTags",
    "ec2:CreateTags",
    "ec2:CreateSnapshot",
    "ec2:DeleteSnapshot"
  ]
}
