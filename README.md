# My notes to learn
## Terraform components
### Terraform executable
### Terraform files
### Terraform plugins
### Terraform state

## Resource types 
### Input Variables
#### Use to create a variable. You can also assign a default value in case value not passed when variable used. Variable can be of type string, number, bool, list(<type>), set(<type>), map(<type>), object(<{<ATTR_NAME> = <TYPE>}), tuple. 
 
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
  
### Output Variables

### Variables Lab

#### Create a tarraform file(variable.tf) using string, list and map types of variable. Pass variable values through file tarraform.tfvars file when runnning "terraform apply". 
