provider "aws" {
  region = "us-east-1"
}

# Tu llave para entrar sin contraseña
resource "aws_key_pair" "calgary_project_key" {
  key_name   = "Calgary_Project_Key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCXnAhjwlz71Itiop+mp04/IZF96Fz/nkDeV5vUl4VWEQrptcGC9PJyuSEHBO0YKsCuY/3dsTHZ41ar+8G1yIqawlHbeZBfCzsTA41C+dry/43ARd2cZNlGiKEuzV0vVrCiKTImuPlWCN4svpLpxK+SGNFfnAfZ87BMpKwiD/3n97nb2RXniUOLJllgOW2Y1wMfMN1esg3HXgnOk6e/kqxtSUyf8D8fMYUidf2e+VQexXHN2C6QmSSjrgFI9PSYM9YXN4QHjiKUc8SMhDZlZSg0XAFXh6BES1H2IwI5Fagcd1IUGkpCHiIiw8V45P72LorF4uxdus36ICkVqROvhpRtwK7RsG4Bu2mhST3GmGVU/umPN5eODQxDVu0Gbxf0229iounUA0b7+qQbv+70JqMPjhEHrqwxEGKj7fMRigjoqpk97Md0BoKPgvzeUTlxZ9qK7XzYbXrSt0VFc/zV5yCu1EHQTfgGYMxQH6mZJCh1tlWiB6uTl3lX2jPOS7F+OSHqCZ9OicCsSRhbaax8trot+4PxoyEtkRPoMbOUTQcjOnkVE8twQsWpMWSItbtx3c4IkuC9rLAIssZq7E9RgbsrZiwrg2rnq0RjfA+Ec7gwSzUjeOtI+kS+G79S09gekJCQrzOtNcnK3m8K2N/acxHHo96XUO8EK4Fw/rOsiXdN2w== dark@192.168.1.14"
}

# Firewall: Solo permite SSH
resource "aws_security_group" "calgary_sg" {
  name        = "Calgary_Project_SG"
  description = "Security Group para el proyecto de Christian"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 2222 # <--- Cambia de 22 a 2222
    to_port     = 2222
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

# La Instancia (Hardware optimizado)
# Buscador dinámico de la imagen más reciente de Amazon Linux 2023
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    # El * permite que coincida con cualquier versión de fecha (ej. al2023-ami-2023.0.1234...)
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"] 
  }
}

# La Instancia
resource "aws_instance" "calgary_server" {
  ami                    = data.aws_ami.amazon_linux_2023.id # <--- Aquí usamos el buscador
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.calgary_project_key.key_name
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.calgary_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y zram-generator
              echo -e "[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd" > /etc/systemd/zram-generator.conf
              systemctl daemon-reload
              systemctl start /dev/zram0
              hostnamectl set-hostname Calgary-Project-Server
              EOF

  tags = {
    Name = "Calgary_Project_Instance"
  }
}

output "ssh_command" {
  value = "ssh ec2-user@${aws_instance.calgary_server.public_ip}"
}
