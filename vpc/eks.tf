module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.14.0"

  name    = "eks-1"

  kubernetes_version = "1.29"

  vpc_id = aws_vpc.demo-vpc.id

  subnet_ids = [
    aws_subnet.private-subnet-1.id,
    aws_subnet.private-subnet-2.id
  ]

 
  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      labels = {
        Environment = "test"
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
