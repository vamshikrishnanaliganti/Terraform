resource "aws_instance" "bastion" {
  ami                         = "ami-0261755bbcb8c4a84"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.sub1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = "newkey"

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_instance" "webserver1" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.private1.id
   key_name                    = "newkey"
  user_data              = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.private2.id
   key_name                    = "newkey"
  user_data              = base64encode(file("userdata1.sh"))
}

resource "aws_s3_bucket" "example" {
  bucket = "hbdfbddjnfdndndndnkrishna"
}