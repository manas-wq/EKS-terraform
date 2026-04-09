######## EKS iam role and policy  ########
resource "aws_iam_role" "eks" {
    name = "${var.env}-${var.eks_name}-iam-role"
    assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole" 
    }
  ]
}
POLICY
  
}

resource "aws_iam_role_policy_attachment" "EKSClusterPolicy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks.name
}

######## EKS cluster  ########
resource "aws_eks_cluster" "eks" {
    name = "${var.env}-${var.eks_name}"
    role_arn = aws_iam_role.eks.arn
    version = var.eks_version
    vpc_config {
      subnet_ids = [aws_subnet.private_AZ1.id, aws_subnet.private_AZ2.id]

      # endpoint_private_access = false ## Default is false
      # endpoint_public_access = true ## Default is true

    }
    
    access_config {
      #authentication_mode = "CONFIG_MAP" #Deprecated
      authentication_mode = "API"
      bootstrap_cluster_creator_admin_permissions = true ## Default is True
    }

    depends_on = [ aws_iam_role_policy_attachment.EKSClusterPolicy ]

    ## Wait for cluster to be created
    # provisioner "var-exec" {
    #   command = "aws eks wait cluster-active --name ${var.env}-${var.eks_name}"
    # }
}
