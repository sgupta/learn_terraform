resource "aws_instance" "nginx" {
    ami           = data.aws_ami.common.image_id
    instance_type = data.aws_ec2_instance_type_offering.example.instance_type
    key_name      = var.key_name
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]


    connection {
        type = "ssh"
        host = self.public_ip
        user = "ec2-user"
        private_key = file(var.private_key_path)
    }


    provisioner "remote-exec" {
        inline = [
            "sudo yum install nginx -y",
            "sudo service nginx start"
        ]
    }
}
output "aws_instance_private_ip" {
    value = aws_instance.nginx.private_ip
}
output "aws_instance_public_ip" {
    value = aws_instance.nginx.public_ip
}
