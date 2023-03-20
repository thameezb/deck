resource "aws_iam_role" "k8s_master" {
  name               = "k8s_master_${var.name}"
  description        = "Allows access to other AWS service resources that are required to operate clusters"
  assume_role_policy = data.aws_iam_policy_document.k8s_master.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

resource "aws_iam_role" "k8s_node_group" {
  description        = "Allows EC2 instances to call AWS services on your behalf."
  name               = "k8s_node_group_${var.name}"
  assume_role_policy = data.aws_iam_policy_document.k8s_node_group.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    aws_iam_policy.ipv6.arn,
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}
