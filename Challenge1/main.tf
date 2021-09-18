# Source the module alb,db and vpc.
# Pass the Parameters to the module

module "alb" {
  source      = "./modules/alb" 
  namespace   = var.namespace 
  ssh_keypair = var.ssh_keypair 
  vpc         = module.vpc.vpc 
  sg          = module.vpc.sg 
  db_config   = module.db.db_config 

}

module "db" {
  source    = "./modules/db" 
  namespace = var.namespace 

    vpc = module.vpc.vpc 
  sg  = module.vpc.sg 

}

module "vpc" {
  source    = "./modules/vpc" 
  namespace = var.namespace 
}
