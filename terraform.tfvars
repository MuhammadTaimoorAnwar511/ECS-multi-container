# VPC
region          = "us-east-1"
vpc_name        = "project-vpc"
vpc_cidr        = "10.0.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

# Security Group
sg_name             = "project-alb-sg"
ecs_service_sg_name = "project-ecs-service-sg"

# ALB + TG
alb_name          = "project-alb"
target_group_name = "project-tg"

# ECS Cluster
cluster_name = "project-cluster"

want_to_create_taskdef_and_service = true

# ECS Task Definition
task_family = "project-task"
task_cpu    = "512"
task_memory = "1024"

containers = [
  {
    name              = "redis"
    image             = "redis:alpine"
    port              = 6379
    cpu               = 128
    gpu               = ""
    memory_hard_limit = 256
    memory_soft_limit = 128
    essential         = true
    environment       = []
    dependencies      = []
    health_check = {
      command     = ["CMD-SHELL", "redis-cli ping | grep PONG"]
      interval    = 30
      retries     = 3
      startPeriod = 10
      timeout     = 5
    }
    
  },
  {
    name              = "project-app"
    image             = "084828600005.dkr.ecr.us-east-1.amazonaws.com/taimoor/project:latest"
    port              = 5000
    cpu               = 256
    gpu               = ""
    memory_hard_limit = 512
    memory_soft_limit = 256
    essential         = true
    environment = [
      { name = "PORT", value = "5000" },
      { name = "MONGODB_URI", value = "mongodb+srv://i211232:2r7SuFkegy9xohZy@cluster0.pvffmnh.mongodb.net/taimoor" },
      { name = "REDIS_URL", value = "redis://127.0.0.1:6379" }
    ]
    dependencies = [
      { containerName = "redis", condition = "HEALTHY" }
    ]
    # 🚫 No healthCheck block here
  }
]


# Service
ecs_service_name              = "project-service"
desired_count                 = 1
min_count                     = 1
max_count                     = 2
scaling_policy_name           = "project-scaling-policy"
scaling_metric                = "ECSServiceAverageCPUUtilization"
load_balanced_container_name  = "project-app"
load_balanced_container_port  = 5000

# Tags
environment = "development"
owner       = "devops-team"
