#! key-pair (login)

resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

#! vpc and security group

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "this will add a tf generated security group"
  vpc_id      = aws_default_vpc.default.id #interpolation

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "flask app"
  }

  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"
  }
  tags = {
    Name = "automate-sg"
  }
}


#! ec2 instance

resource "aws_instance" "my_instance" {
  for_each = ({
    tws-devops-automate-micro  = "t2.micro",
    tws-devops-automate-medium = "t2.medium",
  })

  depends_on = [ aws_security_group.my_security_group,aws_key_pair.my_key]

  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id #ubuntu
  user_data       = file("install_nginx.sh")

  root_block_device {
    volume_size = var.env == "prd" ? 20 : ec2_default_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}

h