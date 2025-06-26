


resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "sub1" {
    vpc_id     = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "test" {
  ami           = var.amiid
  instance_type = var.instance_type
  key_name      = var.key
  subnet_id     = aws_subnet.sub1.id
  tags = {
        Name = "TestInstance"
    }
}




