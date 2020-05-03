# My notes to learn
## Terraform components
### Terraform executable
### Terraform files
### Terraform plugins
### Terraform state

## Resource types 
### Variables
#### Use to create a variable. You can also assign a default value in case value not passed when variable used
    ``` 
      variable "aws_access_key" {} # This variable can be used as "var.aws_access_key" inside terraform plan
      variable "aws_region" {
         default = "us-east-1"  #Default value in case var.aws_region called and no value passed for variable.
         }
    ```
 ### Assigning Variables 
 #### There are mutiple ways to assign variables. The order below is also the order in which variable value are choosen
   1. Command-line flags - 
        $terraform apply -var "region=us-east1" -var "instance_type=t2.micro" -var "foo=bar"
   2. Using "terraform.tfvars" file - 
      $cat terraform.tfvars
        region = "us-east-1"
        instance_type="t2.micro"
 
