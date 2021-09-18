output "db_password" {
value = module.db.db_config.password
}

output "lb_dns_name" {
  value = module.alb.lb_dns_name
}
