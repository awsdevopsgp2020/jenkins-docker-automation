
provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins-docker-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04 (update if needed)
  instance_type = "t2.micro"
  key_name      = "your-key-name"

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  user_data = file("user-data.sh")

  tags = {
    Name = "jenkins-docker-ec2"
  }
}
