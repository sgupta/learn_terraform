resource "aws_instance" "example" {
    ami           = data.aws_ami.common.image_id
    instance_type = data.aws_ec2_instance_type_offering.example.instance_type
}

output "aws_instance_private_ip" {
    value = aws_instance.example.private_ip
}
