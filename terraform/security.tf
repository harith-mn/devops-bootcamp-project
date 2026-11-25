resource "aws_security_group" "my_public_sg" {
  name   = "devops-public-sg"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "devops-public-sg"
  }
}

resource "aws_security_group" "my_private_sg" {
  name   = "devops-private-sg"
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "devops-private-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.my_public_sg.id
  description       = "Allow HTTP (TCP 80) from anywhere"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "public_ssh" {
  security_group_id = aws_security_group.my_public_sg.id
  description       = "Allow SSH (TCP 22) from any subnet inside VPC"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/24"
}

resource "aws_vpc_security_group_ingress_rule" "public_node_exporter" {
  security_group_id = aws_security_group.my_public_sg.id
  description       = "Allow Prometheus Node Exporter (TCP 9100) from monitoring server 10.0.0.136"
  from_port         = 9100
  to_port           = 9100
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.136/32"
}

resource "aws_vpc_security_group_egress_rule" "public_all" {
  security_group_id = aws_security_group.my_public_sg.id
  description       = "Allow all outbound IPv4 traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh" {
  security_group_id = aws_security_group.my_private_sg.id
  description       = "Allow SSH (TCP 22) from any subnet inside VPC"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.0.0.0/24"
}

resource "aws_vpc_security_group_egress_rule" "private_all" {
  security_group_id = aws_security_group.my_private_sg.id
  description       = "Allow all outbound IPv4 traffic"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
