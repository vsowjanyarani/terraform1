
#verify the provider as AWS with profile and region
provider "aws"{
 region = "us-east-2"
 profile = "default"
}
#create a key-pair
resource "tls_private_key" "task1_key"{
algorithm = "RSA"
}

resource "local_file" "mykey_file"{
content = tls_private_key.task1_key.private_key_pem
filename = "mykey.pem"
}

resource "aws_key_pair" "mygenerate_key"{
key_name = "mykey"
public_key = tls_private_key.task1_key.public_key_openssh
}
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.mygenerate_key.key_name}.pem"
  content = tls_private_key.task1_key.private_key_pem
}

#Create a security group allowing port 22 for ssh login and allowing port 80 for HTTP protocol
resource "aws_security_group" "task1_securitygroup" {
name = "task1_securitygroup"
description = "Allow http and ssh traffic"
}
variable "ami_id" {
default = "ami-0aeb7c931a5a61206"
}
resource "aws_instance" "myos" {
ami = var .ami_id
instance_type = "t2.micro"
key_name = aws_key_pair.mygenerate_key.key_name
security_groups = [aws_security_group.task1_securitygroup.name]
vpc_security_group_ids = [aws_security_group.task1_securitygroup.id]

connection {
type = "ssh"
user = "ec2-user"
private_key = tls_private_key.task1_key.private_key_pem
port = 22
host = aws_instance.myos.public_ip
}
tags = {
Name = "sowjanya-tf-instance2"
}
}
resource "null_resource" "copy-test-file" {
 connection {
 type = "ssh"
 user = "ec2-user"
 private_key = tls_private_key.task1_key.private_key_pem
 port = 22
 host = aws_instance.myos.public_ip
}
provisioner "file" {
   source      = "playbook3.yml"
   destination = "/tmp/playbook.yml"
  }
}
resource "null_resource" "copy-test-file2" {
 connection {
 type = "ssh"
 user = "ec2-user"
 private_key = tls_private_key.task1_key.private_key_pem
 port = 22
 host = aws_instance.myos.public_ip
}
 provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y software-properties-common",
    "sudo apt-add-repository ppa:ansible/ansible",
    "sudo apt-get update",
    "sudo apt-get install -y ansible"
   ]
 }
#provisioner "remote-exec" {
 #inline = [
  # "sleep 120; ansible-playbook playbook3.yml"
 # ]
#}
 depends_on = [ aws_instance.myos ]
}

