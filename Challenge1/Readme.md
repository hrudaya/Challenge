Every workspace has a root module it’s the directory where you run terraform apply.
Under the root module, you may have one or more child modules to help you organze and reuse configuration. Modules can be sourced either locally (meaning they are
embedded within the root module) or remotely (meaning they are downloaded from
a remote location as part of terraform init). In this scenario, we will use a locally and remotely sourced modules


We set variables by using a variables definition file. The variables definition file allows
you to parameterize configuration code without having to hardcode default values. It
uses the same basic syntax as Terraform configuration but consists only of variable
names and assignments. 

Standard Module Structure:
  main.tf—the primary entry point
  outputs.tf—declarations for all output values
  variables.tf—declarations for all input variables
  
Architecture  

![image](https://user-images.githubusercontent.com/32632363/133883949-ef715974-2259-4417-b39c-11286b3df83b.png)


