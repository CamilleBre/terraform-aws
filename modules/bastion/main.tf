# recupération dynamique de l'image avec les data sources
data "aws_ami" "datascientest-ami" { # déclaration de la source de données de type aws_ami (ami aws)
  most_recent = true          # demande à avoir l'image la plus recente disponible
  owners      = ["amazon"]    # Le proriétaire de l'image

  filter {                    # on ajoute un filtre
    name   = "name"  
    values = ["amzn2-ami-hvm*"]         # on veut filtrer l'image lorsque le nom commence par amzn2-ami-hvm-*
  }
}


resource "aws_instance" "datascientest_bastion" {
  ami                    = data.aws_ami.datascientest-ami.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_a_id
  vpc_security_group_ids = [var.sg22_id]
  key_name               = var.ec2_key_name

  tags = {
    Name        = "datascientest-bastion"
  }

}

