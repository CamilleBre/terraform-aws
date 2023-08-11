#Créez une Data Source aws_ami pour sélectionner l'ami disponible dans votre région
data "aws_ami" "datascientest-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

## Création du serveur datascientest pour le sous-réseau d'application A
#resource "aws_instance" "datascientest_a" {
#    ami = data.aws_ami.datascientest-ami.id
#  instance_type          = "t2.micro"
#  subnet_id              = var.app_subnet_a_id
#  vpc_security_group_ids = [var.sg_id]
#  key_name               = var.ec2_key_name
#  user_data = "${file("install_wordpress.sh")}"
#  tags = {
#    Name        = "Datascientest-a"
#  }
#}


## Création de serveur datascientest pour le sous-réseau d'application B

#resource "aws_instance" "datascientest_b" {
#    ami = data.aws_ami.datascientest-ami.id
#  instance_type          = "t2.micro"
#  subnet_id              = var.app_subnet_b_id
#  vpc_security_group_ids = [var.sg_id]
#  key_name               = var.ec2_key_name
#  user_data = "${file("install_wordpress.sh")}"
#  tags = {
#    Name        = "Datascientest-alb-sg"
#  }

#}


resource "aws_launch_configuration" "datascientest_a" {
  image_id        = data.aws_ami.datascientest-ami.id
  instance_type   = "t2.micro"
  #subnet_id       = var.app_subnet_a_id
  user_data       = "${file("install_wordpress.sh")}"
  security_groups = [var.sg_id]
  key_name        = var.ec2_key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "datascientest_b" {
  image_id        = data.aws_ami.datascientest-ami.id
  instance_type   = "t2.micro"
  #subnet_id       = var.app_subnet_b_id
  user_data       = "${file("install_wordpress.sh")}"
  security_groups = [var.sg_id]
  key_name        = var.ec2_key_name

  lifecycle {
    create_before_destroy = true
  }
}