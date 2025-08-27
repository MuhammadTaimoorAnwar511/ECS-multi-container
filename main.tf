# (ROOT)main
module "vpc" {
  source              = "./modules/vpc"
  name                = var.vpc_name
  cidr                = var.vpc_cidr
  azs                 = var.azs
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  enable_dns_support  = true
  enable_dns_hostnames= true
  enable_nat_gateway  = true
  single_nat_gateway  = true
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

module "alb_sg" {
  source  = "./modules/alb-securitygroup"
  sg_name = "alb-sg"
  vpc_id  = module.vpc.vpc_id
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

module "ecs_service_sg" {
  source         = "./modules/ecs-service-securitygroup"
  sg_name        = var.ecs_service_sg_name
  vpc_id         = module.vpc.vpc_id
  alb_sg_id      = module.alb_sg.alb_sg_id
  container_port = var.load_balanced_container_port
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

module "target_group" {
  source            = "./modules/target-group"
  target_group_name = "project-tg"
  vpc_id            = module.vpc.vpc_id
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

module "alb" {
  source          = "./modules/alb"
  alb_name        = var.alb_name
  alb_sg_id       = module.alb_sg.alb_sg_id
  public_subnets  = module.vpc.public_subnets
  target_group_arn= module.target_group.target_group_arn
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}

module "ecs_cluster" {
  source       = "./modules/ecs-cluster"
  cluster_name = var.cluster_name
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}
module "ecs_taskdef" {
  count   = var.want_to_create_taskdef_and_service ? 1 : 0
  source  = "./modules/ecs-taskdef"

  family  = var.task_family
  cpu     = var.task_cpu
  memory  = var.task_memory
  region  = var.region
  tags    = var.tags

  containers = var.containers
}

module "ecs_service" {
  count   = var.want_to_create_taskdef_and_service ? 1 : 0
  source  = "./modules/ecs-service"

  service_name       = var.ecs_service_name
  cluster_id         = module.ecs_cluster.ecs_cluster_id
  cluster_name       = module.ecs_cluster.ecs_cluster_name
  task_definition_arn = module.ecs_taskdef[0].task_definition_arn

  desired_count = var.desired_count
  min_count     = var.min_count
  max_count     = var.max_count

  container_name = var.load_balanced_container_name
  container_port = var.load_balanced_container_port

  private_subnets   = module.vpc.private_subnets
  ecs_service_sg_id = module.ecs_service_sg.ecs_service_sg_id
  target_group_arn  = module.target_group.target_group_arn

  scaling_policy_name = var.scaling_policy_name
  scaling_metric      = var.scaling_metric
  tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}



