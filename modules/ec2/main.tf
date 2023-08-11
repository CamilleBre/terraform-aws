#Créez une Data Source aws_ami pour sélectionner l'ami disponible dans votre région
data "aws_ami" "datascientest-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_configuration" "datascientest_a" {
  image_id        = data.aws_ami.datascientest-ami.id
  instance_type   = "t2.micro"
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
  user_data       = "${file("install_wordpress.sh")}"
  security_groups = [var.sg_id]
  key_name        = var.ec2_key_name

  lifecycle {
    create_before_destroy = true
  }
}