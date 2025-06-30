#creating vpc

resource "aws_vpc" "custvpc" {
 
 cidr_block = var.vpc_cidr

  tags = {
    Name = "custvpc"
  }
}


#creating public subnet1

resource "aws_subnet" "public1" {

    vpc_id = aws_vpc.custvpc.id
    cidr_block = var.public1
    availability_zone = "us-east-1a" 
    map_public_ip_on_launch = true

    tags = {
    Name = "public1"
  }
  
}
resource "aws_subnet" "public2" {

    vpc_id = aws_vpc.custvpc.id
    cidr_block = var.public2
    availability_zone = "us-east-1b" 
    map_public_ip_on_launch = true
  tags = {
    Name = "public2"
  }
}

#creating private subnets 

resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.custvpc.id
    cidr_block = var.private1
    availability_zone = "us-east-1a"

  tags ={
    Name = "private1"
  }

}

resource "aws_subnet" "private2" {
  vpc_id = aws_vpc.custvpc.id
    cidr_block = var.private2
    availability_zone = "us-east-1b"
    tags ={
    Name = "private2"
  }
}


resource "aws_internet_gateway" "my_igw" {

  vpc_id = aws_vpc.custvpc.id
  
}



resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.custvpc.id
   
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
    tags ={
      Name = "public_RT"
    }
  }




resource "aws_route_table_association" "public_RT1" {

  route_table_id = aws_route_table.public_RT.id
  subnet_id = aws_subnet.public1.id
  
}


resource "aws_route_table_association" "public_RT2" {

  route_table_id = aws_route_table.public_RT.id
  subnet_id = aws_subnet.public2.id
  
}




resource "aws_route_table" "private-rt" {
 vpc_id = aws_vpc.custvpc.id


 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
    tags ={
      Name = "private_RT"
    }
    
  }


resource "aws_route_table_association" "private1" {
  route_table_id = aws_route_table.private-rt.id
subnet_id = aws_subnet.private1.id
  
}


resource "aws_route_table_association" "private2" {

route_table_id = aws_route_table.private-rt.id
subnet_id = aws_subnet.private2.id
  
}




resource "aws_eip" "eip" {

  
}

resource "aws_nat_gateway" "nat" {

subnet_id = aws_subnet.public1.id
allocation_id = aws_eip.eip.id
tags = {
  Name="nat"
}
  
}















