resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "devops-vpc"
  }
}

resource "aws_subnet" "my_public_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "devops-public-subnet"
  }
}

resource "aws_subnet" "my_private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "devops-private-subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "devops-igw"
  }
}

resource "aws_eip" "my_eip_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_ngw" {
  allocation_id = aws_eip.my_eip_nat.id
  subnet_id     = aws_subnet.my_public_subnet_1.id

  tags = {
    Name = "devops-ngw"
  }

  depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_route_table" "my_route_table_public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "devops-public-route"
  }
}

resource "aws_route_table" "my_route_table_private" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "devops-private-route"
  }
}

resource "aws_route" "my_route_public" {
  route_table_id         = aws_route_table.my_route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route" "my_route_private" {
  route_table_id         = aws_route_table.my_route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_ngw.id
}

resource "aws_route_table_association" "my_link_public_1" {
  subnet_id      = aws_subnet.my_public_subnet_1.id
  route_table_id = aws_route_table.my_route_table_public.id
}

resource "aws_route_table_association" "my_link_private_1" {
  subnet_id      = aws_subnet.my_private_subnet_1.id
  route_table_id = aws_route_table.my_route_table_private.id
}
