locals {
    tags = {
        env = var.env
        aws_region = var.aws_region
        eks_name = var.eks_name
        project = "terraform-eks-demo"
        created_by = "Mo - DevOps_Team" 
    }
    
    aws_account_id = data.aws_caller_identity.current.account_id

}

data "aws_caller_identity" "current" {}
