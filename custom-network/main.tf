resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"

    tags={

        Name ="myvpc"
    }
  
}



resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}



resource "aws_subnet" "pvt-subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "pvt-subnet"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  depends_on = [ aws_vpc.myvpc ]
}

resource "aws_eip" "aws_eip" {

}

resource "aws_nat_gateway" "cust-nat" {
  subnet_id         = aws_subnet.public_subnet1.id
  connectivity_type = "public"
  allocation_id     = aws_eip.aws_eip.id

  tags = {
    Name = "3-tier-nat"
  }
}

resource "aws_route_table" "pbRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "rt1" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.pbRT.id

  
}


resource "aws_route_table" "pvRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cust-nat.id
  }
}


resource "aws_route_table_association" "rt2" {
    subnet_id = aws_subnet.pvt-subnet.id
    route_table_id = aws_route_table.pvRT.id

  
}


#---------------------------------------------------------------------------



resource "aws_security_group" "bastion-host-sg" {
  vpc_id     = aws_vpc.myvpc.id
  depends_on = [aws_vpc.myvpc]

  ingress {
    description = "Allow traffic from web layer"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


 ingress {
    description = "Allow traffic from web layer"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


   ingress {
    description = "Allow traffic from web layer"
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
    Name = "bastion-host-sg"
  }

}


resource "aws_instance" "back" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    key_name = "pub"
    subnet_id = aws_subnet.public_subnet1.id
    vpc_security_group_ids = [aws_security_group.bastion-host-sg.id]
    tags = {
      Name= "bastion-server"
    }
}


resource "aws_instance" "pvt" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    key_name = "pub"
    subnet_id = aws_subnet.pvt-subnet.id
    vpc_security_group_ids = [aws_security_group.bastion-host-sg.id]
    tags = {
      Name= "pvt"
    }
}
