resource "aws_vpc" "three-tier-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "3-tier-vpc"
  }

}

#--------------------------------public--------------------------------------------
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.three-tier-vpc.id
  cidr_block              = var.public_subnet-1_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet1"
  }
}




resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.three-tier-vpc.id
  cidr_block              = var.public_subnet-2_cidr
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {

    Name = "public_subnet2"
  }
}
#---------------------------------frontend-----------------------------------------------------------------------------

resource "aws_subnet" "frontnend_subnet1" {
  vpc_id            = aws_vpc.three-tier-vpc.id
  cidr_block        = var.frontnend_subnet1_cidr
  availability_zone = "ap-south-1a"


  tags = {

    Name = "frontnend_subnet1"

  }
}


resource "aws_subnet" "frontnend_subnet2" {
  vpc_id            = aws_vpc.three-tier-vpc.id
  cidr_block        = var.frontnend_subnet2_cidr
  availability_zone = "ap-south-1b"


  tags = {
    Name = "frontnend_subnet2"


  }
}


#-------------------------backend-----------------------------------------------------------------

resource "aws_subnet" "backend_subnet1" {
  vpc_id            = aws_vpc.three-tier-vpc.id
  cidr_block        = var.backend_subnet1_cidr
  availability_zone = "ap-south-1a"


  tags = {
    Name = "backend_subnet1"


  }
}


resource "aws_subnet" "backend_subnet2" {
  vpc_id            = aws_vpc.three-tier-vpc.id
  cidr_block        = var.backend_subnet2_cidr
  availability_zone = "ap-south-1b"


  tags = {
    Name = "backend_subnet2"

  }
}

#---------------RDS-----------------------------------------------------------------------------------

resource "aws_subnet" "rds_subnet1" {
  vpc_id            = aws_vpc.three-tier-vpc.id
  cidr_block        = var.rds_subnet1_cidr
  availability_zone = "ap-south-1a"


  tags = {
    Name = "rds_subnet1"

  }
}


resource "aws_subnet" "rds_subnet2" {
  vpc_id            = aws_vpc.three-tier-vpc.id
  cidr_block        = var.rds_subnet2_cidr
  availability_zone = "ap-south-1b"
  tags = {
    Name = "something"
  }

}

#----internetGateway--------------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three-tier-vpc.id
}

#--------nat------------


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



#-----------------------------rt---------------------------------------------------
resource "aws_route_table" "pbRT" {
  vpc_id = aws_vpc.three-tier-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.pbRT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.pbRT.id
}



#-----------private RT-------------------------------------------------------------------



#  creating private route table 
resource "aws_route_table" "prvt-rt" {
  vpc_id = aws_vpc.three-tier-vpc.id
  tags = {
    Name = "3-tier-privt-rt"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.cust-nat.id
  }
}

#  attaching prvt-3a subnet to private route table
resource "aws_route_table_association" "prvivate-3a" {
  route_table_id = aws_route_table.prvt-rt.id
  subnet_id      = aws_subnet.frontnend_subnet1.id
}

#  attaching prvt-4b subnet to private route table
resource "aws_route_table_association" "prvivate-4b" {
  route_table_id = aws_route_table.prvt-rt.id
  subnet_id      = aws_subnet.frontnend_subnet2.id
}

#  attaching prvt-5a subnet to private route table
resource "aws_route_table_association" "prvivate-5a" {
  route_table_id = aws_route_table.prvt-rt.id
  subnet_id      = aws_subnet.backend_subnet1.id
}

#  attaching prvt-6b subnet to private route table
resource "aws_route_table_association" "prvivate-6b" {
  route_table_id = aws_route_table.prvt-rt.id
  subnet_id      = aws_subnet.backend_subnet2.id
}

#  attaching prvt-7a subnet to private route table
resource "aws_route_table_association" "prvivate-7a" {
  route_table_id = aws_route_table.prvt-rt.id
  subnet_id      = aws_subnet.rds_subnet1.id
}

#  attaching prvt-8b subnet to private route table
resource "aws_route_table_association" "prvivate-8b" {
  route_table_id = aws_route_table.prvt-rt.id
  subnet_id      = aws_subnet.rds_subnet2.id
}


