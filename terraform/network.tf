resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
	name = "devops-vpc"
  }
}

resource "aws_subnet" "my_public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "ap-southeast-1a"

  tags = {
	name = "devops-public-subnet"
  }
}

resource "aws_subnet" "my_private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "ap-southeast-1a"

  tags = {
	name = "devops-private-subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    name = "devops-igw"
  }
}

resource "aws_eip" "my_eip_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_ngw" {
  allocation_id = aws_eip.my_eip_nat.id
  subnet_id = aws_subnet.my_private_subnet_1.id

  tags = {
    name = "devops-ngw"
  }
}
