
resource "aws_instance" "public" {

    ami = var.amiid
    key_name = var.key
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.bastion-host.id]
    subnet_id = aws_subnet.public1.id
    
  tags = {
    Name = "public"
  }
}


resource "aws_iam_role" "ec2_role" {
  name = "private-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "private-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


resource "aws_instance" "private" {

    ami = var.amiid
    key_name = var.key
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.bastion-host.id]
    subnet_id = aws_subnet.private1.id
    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "hi" > /var/www/html/index.html
  EOF
  tags = {
    Name = "private"
  }
}