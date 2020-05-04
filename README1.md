Chapter 1  - https://github.com/sgupta/learn_terraform/blob/master/README.md
# Output variables

  Output allow you print values for user after terraform apply command is done. This can be used to print information like public   ipaddress of EC2 instance you created or debug information from your plan. You can add "output" anyware the tf files and tarrform will keep track of it to print after apply is done.
  Output values can be access later if you missed when printed on screen using command "terraform output <name>".
  
  Example
  
  ```
   # This will print private ip address of instance name "aws_instance.nginx" created somewhere in tf files
    output "aws_instance_private_ip" {
        value = aws_instance.nginx.private_ip
     }
    
   # This will print public ip address of instance name "aws_instance.nginx" created somewhere in tf files
    output "aws_instance_public_ip" {
        value = aws_instance.nginx.public_ip
    }
    
  ```

# MODULES 

Modules make it easy to reuse and organize terraform resources. 
A Terraform module is a set of Terraform configuration files in a single directory. Even a simple configuration consisting of a single directory with one or more .tf files is a module. When you run Terraform commands directly from such a directory, it is considered the root module. So in this sense, every Terraform configuration is part of a module. You may have a simple set of Terraform configuration files such as:

```
$ tree minimal-module/
.
├── LICENSE
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf

```
In this case, when you run terraform commands from within the minimal-module directory, the contents of that directory are considered the root module.

## Calling modules
 Terraform commands will only directly use the configuration files in one directory, which is usually the current working directory. However, your configuration can use module blocks to call modules in other directories. When Terraform encounters a module block, it loads and processes that module's configuration files.
A module that is called by another configuration is sometimes referred to as a "child module" of that configuration.

## Local and remote modules
 Modules can be either loaded from the local filesystem or remote source. Terraform supports a variety of remote sources, including the Terraform regisitry, most version control systems, HTTP URL. 
 
## Module best practices 
We recommend that every Terraform practitioner use modules by following these best practices:

1. Start writing your configuration with modules in mind. Even for modestly complex Terraform configurations managed by a single person, you'll find the benefits of using modules outweigh the time it takes to use them properly.

2. Use local modules to organize and encapsulate your code. Even if you aren't using or publishing remote modules, organizing your configuration in terms of modules from the beginning will significantlty reduce the burden of maintaining and updating your configuration as your infrastructure grows in complexity.

3. Use the public Terraform Registry to find useful modules. This way you can more quickly and confidently implement your configuration by relying on the work of others to implement common infrastructure scenarios.
https://registry.terraform.io/modules/terraform-aws-modules

4. Publish and share modules with your team. Most infrastructure is managed by a team of people, and modules are important way that teams can work together to create and maintain infrastructure. As mentioned earlier, you can publish modules either publicly or privately. We will see how to do this in a future guide in this series.

## Using modules

In order to use most modules, you will need to pass input variables to the module configuration. The configuration that calls a module is responsible for setting its input values, which are passed as arguments in the module block. Aside from source and version, most of the arguments to a module block will set variable values.
Module documentation should describe all of the input variables that module support. Some input variables are required, meaning that the module doesn't provide a default value — an explicit value must be provided in order for Terraform to run correctly. Example https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.32.0?tab=inputs#required-inputs

## Module use examples 
1.  Below example using aws VPC module from public terraform registry to create a VPC

```
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

```


