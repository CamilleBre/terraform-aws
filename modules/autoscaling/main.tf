#Créez une Data Source aws_ami pour sélectionner l'ami disponible dans votre région
data "aws_ami" "datascientest-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_autoscaling_group" "web_server_a" {
  name              = "web-servers_a"
  min_size          = var.min_instances
  max_size          = var.max_instances
  desired_capacity  = var.min_instances
  launch_configuration = var.datascientest_a_name
  vpc_zone_identifier  = [var.public_subnet_a_id]
}

resource "aws_autoscaling_group" "web_server_b" {
  name              = "web-servers_b"
  min_size          = var.min_instances
  max_size          = var.max_instances
  desired_capacity  = var.min_instances
  launch_configuration = var.datascientest_b_name
  vpc_zone_identifier  = [var.public_subnet_b_id]
}

