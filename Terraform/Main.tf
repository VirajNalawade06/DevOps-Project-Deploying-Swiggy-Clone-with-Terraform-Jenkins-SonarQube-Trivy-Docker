resource "aws_security_group" "DevSecOps" {
  name        = "DevSecOps"
  description = "Open 22,443,80,8080,9000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevSecOps"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-01a00762f46d584a1"
  instance_type          = "m7i-flex.large"
  key_name               = "devopskey"
  vpc_security_group_ids = [aws_security_group.DevSecOps.id]
  user_data              = templatefile("./resource.sh", {})

  tags = {
    Name = "devopskey"
  }
  root_block_device {
    volume_size = 30
  }
}
