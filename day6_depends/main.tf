

provider "aws" {
  region = "us-east-2"
}


resource "aws_instance" "my_ec2" {
  ami           = "ami-0c803b171269e2d72"
  key_name      = "testkey"
  instance_type = "t2.micro"
  availability_zone = "us-east-2b"

  tags = {
    Name = "test1"
  }

}


resource "aws_s3_bucket" "intel" {
  bucket = "dependsonbucketactivatebucketraxyz"

  depends_on = [ aws_instance.my_ec2 ]
}



