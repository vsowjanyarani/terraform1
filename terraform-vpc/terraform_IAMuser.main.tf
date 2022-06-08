ubuntu@ip-172-31-15-88:~$ ls
NginxExample                 go                       playbookex.yml
apache-tomcat-9.0.62         hashicorp.gpg            playbooks
apache-tomcat-9.0.62.tar.gz  javainstallplaybook.yml  playbooksql.yml
calsal.sh                    loops                    shellprogramingpractice
clientServer                 maven2                   t3
clientServer1                mavenplaybook.yml        terraform-ansible
d1                           mavenproject             terraform2Ex
deployplaybook.yml           my-app                   terraformSlackNotify
dockerfile                   nodejsWebserver          terrformEX1
downloads.html               playbook3.yml            test2.txt
gitcloneplaybook.yml         playbookex               volumeExercise
ubuntu@ip-172-31-15-88:~$ cd terrformEX1
ubuntu@ip-172-31-15-88:~/terrformEX1$ ls
terraform-vpc
ubuntu@ip-172-31-15-88:~/terrformEX1$ terraform-vpc
terraform-vpc: command not found
ubuntu@ip-172-31-15-88:~/terrformEX1$ cd terraform-vpc
ubuntu@ip-172-31-15-88:~/terrformEX1/terraform-vpc$ ls
provider.tf  terraform-IAMuser  terraform-s3  terraform-user  vars.tf  vpc.tf
ubuntu@ip-172-31-15-88:~/terrformEX1/terraform-vpc$ cd terraform-IAMuser
ubuntu@ip-172-31-15-88:~/terrformEX1/terraform-vpc/terraform-IAMuser$ ls
main.tf  terraform.tfstate  terraform.tfstate.backup
ubuntu@ip-172-31-15-88:~/terrformEX1/terraform-vpc/terraform-IAMuser$ vi main.tf
 
}
#create a instance profile
resource "aws_iam_instance_profile" "ec2-profile1" {
  name  = "ec2-profile1"
  role = aws_iam_role.sowjanya-role.name
}
#attach the instance profile to EC2 instance
resource "aws_instance" "my-test-instance" {
  ami             = "ami-0aeb7c931a5a61206"
instance_type   = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2-profile1.name
 # the Public SSH key
  key_name = "us-east-2-region-key-pair"
#user_data = templatefile("user_data/user_data.tpl",
#       {
#       serverName  = "var.ServerName"
        #SecureVariable = aws_ssm_parameter.parameter_one.name
#})
associate_public_ip_address = true
tags = {
   Name = "sowjanya-terraforminstance"
}
}
