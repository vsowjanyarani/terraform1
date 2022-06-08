#Create a security group
resource "aws_security_group" "us-ssh-allowedd" {
    vpc_id = "vpc-0aa6bf4f4e53794a6"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["172.27.0.0/16"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh !
        // Do not do it in the production.
        // Put your office or home address in it!
        cidr_blocks = ["172.27.0.0/16"]
    }
}
resource "aws_instance" "namrata-tf-ec2-instance" {
ami = "ami-09d56f8956ab235b3"
instance_type = "t2.micro"
  #iam_instance_profile = aws_iam_instance_profile.namrata_tf_ec2_profile.name
 # the Public SSH key
vpc_security_group_ids = ["${aws_security_group.us-ssh-allowedd.id}"]
key_name = "namrata-us-east-1-kp"
subnet_id = "subnet-0dfbe9707a84ccf51"
associate_public_ip_address = true
tags = {
Name = "namrata-server-2"
}
user_data = <<-EOF
               #!/bin/bash
               sudo apt-get update -y
               sudo apt-get install apache2 -y
               sudo mkfs -t ext4 /dev/xvdh
               sudo mount /dev/xvdh /var/www/html
            EOF
}
//Creating one EBS volume
resource "aws_ebs_volume" "namrata-ebs-tf" {
  #availability_zone = aws_instance.namrata-tf-ec2-instance.availability_zone
   availability_zone = "us-east-1a"
   size              = 10
}
// Attaching this EBS volume with EC2 instance
resource "aws_volume_attachment" "namrata_ebs_att" {
  device_name = "/dev/xvdh"
  volume_id   = "${aws_ebs_volume.namrata-ebs-tf.id}"
  instance_id = "${aws_instance.namrata-tf-ec2-instance.id}"
  force_detach = true
}
#Creating an S3 bucket and make it public readable
resource "aws_s3_bucket" "namrata-ebs2-bucket" {
      bucket = "namrata-ebs2-bucket"
      #bucket = aws_s3_bucket.namrata-ebs2-bucket.bucket
      acl = "public-read"
   tags = {
      Name = "namrata-ebs2-bucket"
      Environment = "Dev"
     }
#Download the image from github
   provisioner "local-exec" {
     command = "git clone https://github.com/namrata4447/upload-images.git namrata-image"
 }
}
resource "aws_s3_object" "image_upload" {
        bucket = aws_s3_bucket.namrata-ebs2-bucket.bucket
        key = "Taj-Mahal.jpg"
        source = "namrata-image/Taj-Mahal.jpg"
        acl = "public-read"
}
