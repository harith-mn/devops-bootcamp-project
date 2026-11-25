data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_iam_instance_profile" "my_ssm_profile" {
  name = "EC2-SSM-Role"
}

resource "aws_instance" "my_server_1" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.my_public_subnet_1.id
  private_ip             = "10.0.0.5"
  vpc_security_group_ids = [aws_security_group.my_public_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "my_server_2" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.my_private_subnet_1.id
  private_ip             = "10.0.0.135"
  vpc_security_group_ids = [aws_security_group.my_private_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  tags = {
    Name = "ansible-controller"
  }
}

resource "aws_instance" "my_server_3" {
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.my_private_subnet_1.id
  private_ip             = "10.0.0.136"
  vpc_security_group_ids = [aws_security_group.my_private_sg.id]
  iam_instance_profile   = data.aws_iam_instance_profile.my_ssm_profile.name

  tags = {
    Name = "monitoring-server"
  }
}

resource "aws_eip" "my_eip_web" {
  instance = aws_instance.my_server_1.id
  domain   = "vpc"
}
