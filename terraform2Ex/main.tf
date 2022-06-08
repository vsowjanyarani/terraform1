
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
#Create a security group allowing port 22 for ssh login and allowing port 80 for HTTP protocol
resource "aws_security_group" "task1_securitygroup" {
name = "task1_securitygroup"
description = "Allow http and ssh traffic"

ingress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
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
#create EBS volume
resource "aws_ebs_volume" "myvolume" {
availability_zone = aws_instance.myos.availability_zone
size = 1
}
#attaching volume to instance
resource "aws_volume_attachment" "ebs_att" {
device_name = "/dev/sdh"
volume_id = aws_ebs_volume.myvolume.id
instance_id = aws_instance.myos.id
force_detach = true
}


/*  resource "aws_s3_bucket" "task1_bucket" {
  bucket = "sowjanya-s3bucket2"
 acl="public-read"
 force_destroy=true


tags = {
    Name = "sowjanya-bucket2"
  }
 provisioner "local-exec" {
    command = "git clone https://github.com/vsowjanyarani/terraform1.git myfolder1"
   }
}

resource "aws_s3_bucket_public_access_block" "aws_public_access" {
  bucket = "${aws_s3_bucket.task1_bucket.id}"


 block_public_acls   = false
  block_public_policy = false
}
resource "aws_s3_bucket_object" "image_upload"{
  bucket = aws_s3_bucket.task1_bucket.bucket
 key = "images.jpg"
  acl = "public-read"
  source = "myfolder1/images.jpg"
} */
#Creating an S3 bucket and make it public readable
resource "aws_s3_bucket" "sowjanya-ebs2-bucket" {
      bucket = "sowjanya-ebs2-bucket"
      #bucket = aws_s3_bucket.sowjanya-ebs2-bucket.bucket
      acl = "public-read"
   tags = {
      Name = "sowjanya-ebs2-bucket"
      Environment = "Dev"
     }
#Download the image from github
   provisioner "local-exec" {
     command = "git clone https://github.com/vsowjanyarani/terraform1.git sowjanya-image"
 }
}
resource "aws_s3_object" "image_upload" {
        bucket = aws_s3_bucket.sowjanya-ebs2-bucket.bucket
        key = "images.jpg"
        source = "sowjanya-image/images.jpg"
        acl = "public-read"
}
