




resource "aws_instance" "dev" {
  ami           = "ami-0d1b5a8c13042c939"
  instance_type = "t2.micro"
  key_name      = "testkey"
  tags = {
        Name = "dev"
    }
}
