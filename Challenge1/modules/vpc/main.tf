# Get the Availibilty zones from Region
data "aws_availability_zones" "available" {}

# Define CIDR Blocks for vpc, public subnet and private subnet as well db subnet
module "vpc" { 
  source                           = "terraform-aws-modules/vpc/aws"
  version                          = "2.64.0"
  name                             = "${var.namespace}-vpc"
  cidr                             = "10.0.0.0/16"
  azs                              = data.aws_availability_zones.available.names
  private_subnets                  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets                   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  db_subnets                       = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  
  create_db_subnet_group           = true
  enable_nat_gateway               = true
  single_nat_gateway               = true
}

# Define Security group for Load balancer  
module "lb_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port        = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]
}
# Define Security group for Web server 
module "webserver_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 8080
      security_groups = [module.lb_sg.security_group.id]
    },
    {
      port        = 22 #C
      cidr_blocks = ["10.0.0.0/16"] #C
    }
  ]
}

# Define Security group for database    
module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port            = 3306
    security_groups = [module.webserver_sg.security_group.id]
  }]
}
