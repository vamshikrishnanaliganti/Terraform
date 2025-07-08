resource "aws_security_group" "bastion-host-sg" {
  vpc_id     = aws_vpc.three-tier-vpc.id
  depends_on = [aws_vpc.three-tier-vpc]

  ingress {
    description = "Allow traffic from web layer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-host-sg"
  }

}

#  alb-frontend-sg

resource "aws_security_group" "alb-frontend-sg" {
  name        = "alb-frontend-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.three-tier-vpc.id
  depends_on  = [aws_vpc.three-tier-vpc]

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-frontend-sg"
  }

}



#  alb-backend-sg

resource "aws_security_group" "alb-backend-sg" {
  name        = "alb-backend-sg"
  description = "Allow inbound traffic ALB"
  vpc_id      = aws_vpc.three-tier-vpc.id
  depends_on  = [aws_vpc.three-tier-vpc]

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-backend-sg"
  }

}


# frontend server sg
resource "aws_security_group" "frontend-server-sg" {
  name        = "frontend-server-sg"
  description = "Allow inbound traffic "
  vpc_id      = aws_vpc.three-tier-vpc.id
  depends_on  = [aws_vpc.three-tier-vpc, aws_security_group.alb-frontend-sg]

  ingress {
    description     = "http from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-frontend-sg.id]
  }
  ingress {
    description     = "ssh from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-host-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-server-sg"
  }

}


#  backend-server-sg


resource "aws_security_group" "backend-server-sg" {
  name        = "backend-server-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.three-tier-vpc.id
  depends_on  = [aws_vpc.three-tier-vpc, aws_security_group.alb-backend-sg]

  ingress {
    description     = "http from ALB backend"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-backend-sg.id]
  }
  ingress {
    description     = "ssh from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-host-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-server-sg"
  }
}



resource "aws_security_group" "book_rds_sg" {
  name        = "book-rds-sg"
  description = "Allow inbound MySQL from backend server"
  vpc_id      = aws_vpc.three-tier-vpc.id
  depends_on  = [aws_vpc.three-tier-vpc]

  ingress {
    description     = "MySQL/Aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend-server-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "book-rds-sg"
  }
}
