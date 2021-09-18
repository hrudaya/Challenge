 
For this scenario, we will split the project into three major components:

- Networking—All networking-related infrastructure, including the VPC, subnets,
  and security groups
- Database—The SQL database infrastructure
- Autoscaling—Load balancer, EC2 autoscaling group, and launch template
  resources
  
  Standards in each Module
  main.tf      — the primary entry point
  outputs.tf   — declarations for all output values
  variables.tf — declarations for all input variable
  
  These three major components are:
  
  ![image](https://user-images.githubusercontent.com/32632363/133884000-89ea5749-f615-41f8-99ce-30423da33a91.png)

  Overall Module structure with nested child structure

![image](https://user-images.githubusercontent.com/32632363/133884026-521ed8f3-3cc7-4f47-b6d5-6ebd33eac85a.png)

  
  
