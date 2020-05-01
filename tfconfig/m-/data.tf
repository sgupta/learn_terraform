data "aws_ami" "common" {
    owners = ["amazon"]
    most_recent = "true"

    filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
    
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ec2_instance_type_offering" "example" {
  filter {
    name   = "instance-type"
    values = ["t1.micro", "t2.micro", "t3.micro"]
  }

  preferred_instance_types = ["t3.micro", "t2.micro", "t1.micro"]
}

output "aws_image_data" {
    value = data.aws_ami.common.image_id
}

output "aws_instance_type" {
    value = data.aws_ec2_instance_type_offering.example.instance_type
}