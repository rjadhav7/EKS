# Datasource: AWS Caller Identity
data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
# Datasource: 
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.eks_cluster.id
}
# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
# Adding Backend as S3 for Remote State Storage
terraform {
    backend "s3" {
    bucket = "ap-s3-terraform-use-poc"
    key    = "eks_config/terraform.tfstate"
    region = "us-east-1"

    # For State Locking
    dynamodb_table = "poc-ekscluster"
  }
}
