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
