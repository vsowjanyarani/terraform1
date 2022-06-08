#Provider profile and region in which all the resources will create
provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

#Resource to create s3 bucket
resource "aws_s3_bucket" "sowjanya-demo-bucket"{
  bucket = "sowjanya-s3-bucket"

  tags = {
    Name = "S3Bucket"
  }
}
