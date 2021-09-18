 
For this scenario, we will split the project into three major components:

- Networking—All networking-related infrastructure, including the VPC, subnets,
  and security groups
- Database—The SQL database infrastructure
- Autoscaling—Load balancer, EC2 autoscaling group, and launch template
  resources
  
  St
  main.tf      — the primary entry point
outputs.tf   — declarations for all output values
variables.tf — declarations for all input variable
  
  