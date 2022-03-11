resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "CuValley"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone
  tags = {
    Name = "Cuvalley-Subnet-1"
  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

resource "aws_route_table" "cuvalley-rt" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Cuvalley Route Table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.cuvalley-rt.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_web"
  }
}

resource "aws_network_interface" "cuvalley-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "cuvalley_eip" {
  vpc                       = true
  network_interface         = aws_network_interface.cuvalley-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw]
}


resource "aws_instance" "cuvalley-ec2" {
  ami               = "ami-04505e74c0741db8d"
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  key_name          = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.cuvalley-nic.id
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    port        = 22
    private_key = file("~/.ssh/cuvalley.pem")
    host        = aws_eip.cuvalley_eip.public_ip
  }

  provisioner "file" {
    source      = "scripts/install_docker.sh"
    destination = "/tmp/install_docker.sh"

  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/install_docker.sh",
      "sudo /tmp/install_docker.sh",
    ]

  }
  provisioner "local-exec" {
    command = "aws ec2 reboot-instances --instance-ids $(self.id)"
  }

  tags = {
    Name = var.instance_name
  }
}
