variable "env" {
    type = string
    default = "dev"
}

variable "eks_name" {
    type = string
    default = "eks-cluster"
}

variable "eks_version" {
    type = string
    default = "1.26"
}   

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "availability_zones" {
    type = list
    default = ["us-east-1a", "us-east-1b"]
}
