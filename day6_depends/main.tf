

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "my_ec2" {
  ami           = "ami-05ffe3c48a9991133"
  key_name      = "vvv"
  instance_type = "t2.nano"


  tags = {
    Name = "test1"
  }

}






