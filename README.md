# My notes to learn
## Terraform components
### Terraform executable
### Terraform files
### Terraform plugins
### Terraform state
 Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.
 This state is stored by default in a local file named "terraform.tfstate", but it can also be stored remotely, which works better in a team environment.
 
 The state is in JSON format and Terraform will promise backwards compatibility with the state file. The JSON format makes it easy to write tools around the state if you want or to modify it by hand in the case of a Terraform bug.
 If supported by your backend, Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.
 State locking happens automatically on all operations that could write state. You won't see any message that it is happening. If state locking fails, Terraform will not continue. You can disable state locking for most commands with the -lock flag but it is not recommended.
 Terraform has a force-unlock command to manually unlock the state if unlocking failed.
#### Local state Stoarge 
 Use below format to define location of terraform state file on local storge
````
terraform {
  backend "local" {
    path = "/mnt/c/Users/sg197_000/terraform_state/terraform_1.tfstate"
  }
}
````

#### Remote State Storage
 In production environments it is considered a best practice to store state elsewahere than your local machine. This best way to do this is by running Terrafrom in a remote environment with shared access to state.
 Terraform supports team-based workflows with a feature knows as "remote backends". Remote backends allow Terraform to use a shared storage space to state data, so any member or your team can use Terraform to manage the same infrastructure.
 Use below format to store terraform state file in Hashicorp Terraform Cloud 

https://www.terraform.io/docs/backends/types/index.html

````
#Hashicorp Terraform Cloud 
terraform {
  backend "remote" {
    organization = "<ORG_NAME>"

    workspaces {
      name = "Example-Workspace"
    }
  }
}

#S3 Bucket 
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}

#HTTP 
terraform {
  backend "http" {
    address = "http://myrest.api.com/foo"
    lock_address = "http://myrest.api.com/foo"
    unlock_address = "http://myrest.api.com/foo"
  }
}

````
 
 
## Resource types 
### Input Variables
 Use to create a variable. You can also assign a default value in case value not passed when variable used. Variable can be of type string, number, bool, list(<type>), set(<type>), map(<type>), object(<{<ATTR_NAME> = <TYPE>}), tuple. 
 
 ``` 
   variable "aws_access_key" {} # This variable can be used as "var.aws_access_key" inside terraform plan
   variable "aws_region" {
        default = "us-east-1"  #Default value in case var.aws_region called and no value passed for variable.
        type    = string #optinal type
        description = "AWS region for resources to be created" # optional description
        
    }
    # Using [] create list style vraible
    variable "cidrs" {
        default = [] 
     }
     
     # Using "type" to declate list type variable
     variable "cidrs" {
        type = list(string)
      }
    
    # Set a variable type list and values as srtings 
    variable "availability_zone_names" {
          type    = list(string)
          default = [ "us-east-1a", "us-east-2a" ]
        }
    
    # Using map style variable. You can use {} to implicitly define it as map or use type=map
    variable "amis" {
        type = "map" 
        default = {
            "us-east-1" = "amis-b374d5a5"
            "us-east-2" = "amis-4b32be2b"
        }
    }
    # Complex list type example. In below example you createing a list variable and each element in list is a map. Docker_ports is list varibale and each element in list is map.
    variable "docker_ports" {
         type = list(object({
     internal = number
     external = number
      protocol = string
      }))
     default = [
     {
      internal = 8300
      external = 8300
      protocol = "tcp"
      }
     ]
   }
     
    
 ```
 ### Assigning Variables 
 #### There are mutiple ways to assign variables. The order below is also the order in which variable value are choosen
   
  1. Command-line flags - 
  
  ```
  $terraform apply -var "region=us-east1" -var "instance_type=t2.micro" -var "foo=bar"
  
  $terraform apply -var "region=us-east1" -var "instance_type=t2.micro" -var "cidrs=[ "10.1.0.0/16", ""10.2.0.0/16" ] 
  
   $terraform apply -var "region=us-east1" -var "instance_type=t2.micro" -var "foo=bar" -var 'amis={ us-east-1 = "foo", us-west-2 = "bar" }'
  ```
  2. Using "terraform.tfvars" file. Terraform automatically loads all files in the current directory with the exact name of terraform.tfvars or any variation of *.auto.tfvars. If the file is named something else, you can use the ''-var-file'' flag to specify a file name - 
   
   ```
       $cat terraform.tfvars
        region = "us-east-1"
        instance_type="t2.micro"
        cidrs=[ "10.1.0.0/16", ""10.2.0.0/16" ] 
        amis= { "us-east-1" = "amis-b374d5a5" ,  "us-east-2" = "amis-4b32be2b" }
        
        $cat dev.auto.tfvars
        foo="bar"
        cidrs=[ "10.1.0.0/16", ""10.2.0.0/16" ] 
        amis= { "us-east-1" = "amis-b374d5a5" ,  "us-east-2" = "amis-4b32be2b" }
        
        $terraform apply -var-file="$HOME/secret.tfvars" -var-file="prd/production.tfvars" #This is good way to keep aws keys out side current directory. 
        
   ```
  3. From environment variables. Terraform will read and pass all environment variable starting with TF_VAR_<VariableName>. This only support string type variable
  
   ```
    export TF_VAR_region="us-east-1"
   
   ```
  4. UI input . If you execute terraform apply with any variable unspecified, Terraform will ask you to input the values interactively.
  
### https://github.com/sgupta/learn_terraform/master/README1.md

