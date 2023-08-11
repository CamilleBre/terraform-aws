## Création de serveurs datascientest pour le sous-réseau d'application A
resource "aws_security_group" "sg_datascientest" {

  name   = "sg_datascientest"
  vpc_id = var.vpc_id
  tags = {
    Name        = "sg-datascientest"
  }

}

resource "aws_security_group_rule" "allow_all" {
  type              = "ingress"
  cidr_blocks       = ["10.1.0.0/24"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_datascientest.id}"
}

resource "aws_security_group_rule" "outbound_allow_all" {
  type = "egress"

  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.sg_datascientest.id}"
}


## Création d'un équilibreur de charge d'application pour accéder à l'application
resource "aws_security_group" "sg_application_lb" {

  name   = "sg_application_lb"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    # Veuillez limiter votre entrée aux seules adresses IP et ports nécessaires.
    # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Datascientest-alb"
  }

}


## Création de la paire de clé du serveur  Bastion

resource "aws_key_pair" "myec2key" {
  key_name   = "datascientest_keypair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "sg_22" {

  name   = "sg_22"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "sg-22"
  }
}

# Créer un NACL pour accéder à l'hôte bastion via le port 22
resource "aws_network_acl" "datascientest_public_a" {
  vpc_id = var.vpc_id

  subnet_ids = [var.public_subnet_a_id]

  tags = {
    Name        = "acl-datascientest-public-a"
  }
}

resource "aws_network_acl" "datascientest_public_b" {
  vpc_id = var.vpc_id

  subnet_ids = [var.public_subnet_b_id]

  tags = {
    Name        = "acl-datascientest-public-b"
  }
}

resource "aws_network_acl_rule" "nat_inbound" {
  network_acl_id = "${aws_network_acl.datascientest_public_a.id}"
  rule_number    = 200
  egress         = false
  protocol       = "-1" #Tous les protocles (TCP/UDP...)
  rule_action    = "allow"
  # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité. vous devez restreindre uniquement l'acces à votre ip publique
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}

resource "aws_network_acl_rule" "nat_inboundb" {
  network_acl_id = "${aws_network_acl.datascientest_public_b.id}"
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité. vous devez restreindre uniquement l'acces à votre ip publique
  cidr_block = "0.0.0.0/0"
  from_port  = 0
  to_port    = 0
}

resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow mysql inbound traffic"
  ingress{
    from_port   = 3306
    to_port     = 3306
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