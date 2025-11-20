module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = "ogunfemi-portfolio-cluster"
  cluster_version = "1.30"

  # Acesso público para você poder controlar o cluster do seu computador
  cluster_endpoint_public_access = true

  # Conectando o EKS à VPC que criamos no Módulo 1
  # O Terraform lê automaticamente os IDs da VPC criada anteriormente
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # Configuração dos "Nodes" (Seus servidores de trabalho)
  # Usamos t3.small para manter o custo baixo no laboratório
  eks_managed_node_groups = {
    portfolio_nodes = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
    }
  }

  # Permissões: Dá acesso de admin ao usuário que criou o cluster (VOCÊ)
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "Portfolio"
    Terraform   = "true"
  }
}