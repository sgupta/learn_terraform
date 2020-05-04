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


#### Create a tarraform file(variable.tf) using string, list and map types of variable. Pass variable values through file tarraform.tfvars file when runnning "terraform apply". 
