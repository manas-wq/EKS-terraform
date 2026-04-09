AWS EKS Cluster using Terraform
=====================================

Overview
This Terraform project to creates a complete AWS EKS cluster (including networking, IAM roles, and security. It also sets up S3 and DynamoDB for Terraform state management.

Resources Created
EKS Cluster and managed Node Group
VPC with public and private subnets
Internet Gateway and NAT Gateway
Route Tables
Required IAM roles and policies
S3 bucket and DynamoDB table for remote tf state (storage and locking)
Requirements
Install Terraform
AWS Account with EKS and EC2 permissions
AWS Cli (update/set credentials with aws configure)
Before You Run Terraform
1. Create S3 Bucket and DynamoDB Table for Backend
Navigate to the backend-creation directory:

cd backend-creation
Initialize Terraform and apply the configuration:

terraform init
terraform apply
This will create the necessary S3 bucket and DynamoDB table for storing and locking the Terraform state.

Note down the outputs for the S3 bucket name and DynamoDB table name.

2. Update the backend.tf File
Open the backend.tf file in the main directory.

Update the bucket and dynamodb_table fields with the values from the previous step:

terraform {
  backend "s3" {
    bucket         = "your-s3-bucket-name"      # Replace with the created bucket name
    key            = "terraform/state.tfstate" # State file path
    region         = "us-east-1"               # Match the region of the bucket
    dynamodb_table = "tf-locking-state"        # Replace with the DynamoDB table name
  }
}
Usage
Just Clone this repo
Ensure the AWS credentials are set correctly using aws configure.
Make sure to update defualt values in variables.tf or create your own terraform.tfvars file as mentioned in last step.
Run terraform init to initialize the project
Run terraform apply terraform apply to create the EKS cluster
