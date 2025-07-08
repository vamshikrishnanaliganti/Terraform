
resource "aws_instance" "back" {
    ami = var.amiid
    instance_type = var.instance_type
    key_name = var.key
    subnet_id = aws_subnet.public_subnet1.id
    vpc_security_group_ids = [aws_security_group.bastion-host-sg.id]
    tags = {
      Name= "bastion-server"
    }
}
