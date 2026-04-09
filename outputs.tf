output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
  description = "EKS cluster name"
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
  description = "EKS cluster endpoint"
}

output "eks_cluster_certificate" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
  description = "EKS cluster certificate"
}

output "eks_cluster_version" {
  value = aws_eks_cluster.eks.version
  description = "EKS cluster version"
}
output "cluster_arn" {
  value = aws_eks_cluster.eks.arn
  description = "EKS cluster arn"
}

## aws account id
output "aws_account_id" {
  value = local.aws_account_id
  description = "AWS account id"
}

## eks cluster kubeconfig
output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --name ${var.env}-${var.eks_name} --region ${var.aws_region}"
  description = "To configure kubectl for the EKS cluster" 
}
