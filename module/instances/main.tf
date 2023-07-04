
# key pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "key-pair"
  public_key = file("~/.ssh/key-pair.pub")
}

# web security group
resource "aws_security_group" "web_sg" {
  name_prefix = "web_sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#db security group
resource "aws_security_group" "db_sg" {
  name_prefix = "db_sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define EC2 instance
resource "aws_instance" "web_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  connection {
    type        = "ssh"
    user        = var.connection_user
    private_key = file("~/.ssh/my-key-pair.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo echo '<h1>Welcome to my website!</h1>' > /var/www/html/index.html",
    ]
  }

  tags = {
    Name = "web-instance"
  }
}

#db instance
resource "aws_instance" "db_instance_1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  connection {
    type        = "ssh"
    user        = var.connection_user
    private_key = file("~/.ssh/my-key-pair.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mysql-server",
      "sudo systemctl start mysqld",
      "sudo systemctl enable mysqld",
      "sudo mysql -e 'CREATE DATABASE my_db;'",
    ]
  }

  tags = {
    Name = "db-instance-1"
  }
}