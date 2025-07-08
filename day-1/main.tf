<<<<<<< HEAD



=======
provider "aws" {
  region = "us-east-1"
}
>>>>>>> 86c60ed87f7128226de306fee41acf741b97ea73

resource "aws_instance" "dev" {
<<<<<<< HEAD
  ami           = "ami-0d1b5a8c13042c939"
  instance_type = "t2.micro"
  key_name      = "testkey"
  tags = {
        Name = "dev"
=======
    ami = "ami-05ffe3c48a9991133"
    instance_type = "t2.nano"
    # key_name      = ""

    tags = {
      Name = "test"
>>>>>>> 86c60ed87f7128226de306fee41acf741b97ea73
    }
}
