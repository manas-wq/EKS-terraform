##### IAM role for EKS node group (for workers) ########
resource "aws_iam_role" "eks-nodegroup" {
    name = "${var.env}-${var.eks_name}-nodegroup"

    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  
}

##### EKS node group policy ########
resource "aws_iam_role_policy_attachment" "EKSNodeGroupPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role = aws_iam_role.eks-nodegroup.name
}

resource "aws_iam_role_policy_attachment" "EKSNodeGroupAmazonEKS_CNI_Policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.eks-nodegroup.name
}   

resource "aws_iam_role_policy_attachment" "EKSNodeGroupAmazonEC2ContainerRegistryReadOnly" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.eks-nodegroup.name
}   


######## EKS node group (for worker nodes) ########
resource "aws_eks_node_group" "eks-nodegroup" {
    cluster_name = "${var.env}-${var.eks_name}"
    node_group_name = "${var.env}-${var.eks_name}-nodegroup"
    node_role_arn = aws_iam_role.eks-nodegroup.arn
    version = var.eks_version
    subnet_ids = [aws_subnet.private_AZ1.id, aws_subnet.private_AZ2.id]

    capacity_type = "ON_DEMAND"
    instance_types = ["m5.large"]
    scaling_config {
      desired_size = 2
      max_size = 3
      min_size = 1

    }

    update_config {
      max_unavailable = 1
    }

    labels = {
      "role" = "${var.eks_name}-workers"
    }
    
    depends_on = [
      aws_iam_role_policy_attachment.EKSNodeGroupPolicy,
      aws_iam_role_policy_attachment.EKSNodeGroupAmazonEKS_CNI_Policy,
      aws_iam_role_policy_attachment.EKSNodeGroupAmazonEC2ContainerRegistryReadOnly,
      
      ## Wait for cluster to be created
      aws_eks_cluster.eks
    ]

}
