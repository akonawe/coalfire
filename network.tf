###### VPC ######  
resource "aws_vpc" "coalfire_VPC" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "coalfire_VPC"
  }
}

###### Public Subnets ######

resource "aws_subnet" "public_sub1" {
  vpc_id     = "${aws_vpc.coalfire_VPC.id}"
  cidr_block = "10.1.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_sub1"
  }
}

resource "aws_subnet" "public_sub2" {
  vpc_id     = "${aws_vpc.coalfire_VPC.id}"
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1b" 
  map_public_ip_on_launch = true 

  tags = {
    Name = "public_sub2"
  }
}

resource "aws_internet_gateway" "coalfire_VPC_igw" {
    vpc_id = "${aws_vpc.coalfire_VPC.id}"
  
    tags = {
      "Name" = "CoalFire VPC - IGW"
    }
}

resource "aws_route_table" "vpc_public" {
    vpc_id = "${aws_vpc.coalfire_VPC.id}" 

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.coalfire_VPC_igw.id}"
    }

    tags = {
      "Name" = "Public subnets route table for CoalFire VPC"
    }
}

resource "aws_route_table_association" "coalfire_VPC_us_east_1a_public" {
    subnet_id = aws_subnet.public_sub1.id
    route_table_id = aws_route_table.vpc_public.id
}

resource "aws_route_table_association" "coalfire_VPC_us_east_1b_public" {
    subnet_id = aws_subnet.public_sub2.id 
    route_table_id = aws_route_table.vpc_public.id
}

###### Security Group ######

resource "aws_security_group" "allow_http" {
  name = "allow_http"
  description = "Allow all HTTP inboud connections"
  vpc_id = aws_vpc.coalfire_VPC.id 

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  } 

  ingress {
    description = "allow ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow HTTP Security Group"
  }

}

###### Private Subnets ######

resource "aws_subnet" "private_sub3" {
  vpc_id     = "${aws_vpc.coalfire_VPC.id}"
  cidr_block = "10.1.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_sub3"
  }
}

resource "aws_subnet" "private_sub4" {
  vpc_id     = "${aws_vpc.coalfire_VPC.id}"
  cidr_block = "10.1.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_sub4"
  }
}
    
     