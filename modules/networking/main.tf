### Creation du vpc datascientest
resource "aws_vpc" "datascientest_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "datascientest-vpc"
  }
}

### Creation des 2 sous-réseaux public pour les serveurs datascientest

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = "${aws_vpc.datascientest_vpc.id}"
  cidr_block              = "${var.cidr_public_subnet_a}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.az_a}"

  tags = {
    Name        = "public-a"
    #Environment = "${var.environment}"
  }

  depends_on = [aws_vpc.datascientest_vpc]
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = "${aws_vpc.datascientest_vpc.id}"
  cidr_block              = "${var.cidr_public_subnet_b}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.az_b}"

  tags = {
    Name        = "public-b"
    #Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.datascientest_vpc]
}

### Creation des 2 sous-réseaux privées pour les serveurs datascientest
resource "aws_subnet" "app_subnet_a" {

  vpc_id     = "${aws_vpc.datascientest_vpc.id}"
  cidr_block = "${var.cidr_app_subnet_a}"
  availability_zone = "${var.az_a}"

  tags = {
    Name        = "app-a"
    #Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.datascientest_vpc]
}


resource "aws_subnet" "app_subnet_b" {

  vpc_id     = "${aws_vpc.datascientest_vpc.id}"
  cidr_block = "${var.cidr_app_subnet_b}"
  availability_zone = "${var.az_b}"

  tags = {
    Name        = "app-b"
    #Environment = "${var.environment}"
  }
  depends_on = [aws_vpc.datascientest_vpc]
}


# Créer une passerelle Internet pour notre VPC
resource "aws_internet_gateway" "datascientest_igateway" {
  vpc_id = "${aws_vpc.datascientest_vpc.id}"

  tags = {
    Name        = "datascientest-igateway"
  }

  depends_on = [aws_vpc.datascientest_vpc]
}


# Créez une table de routage afin que nous puissions attribuer un sous-réseau public-a et public-b à cette table de routage
resource "aws_route_table" "rtb_public" {

  vpc_id = "${aws_vpc.datascientest_vpc.id}"
  tags = {
    Name        = "datascientest-public-routetable"
  }

  depends_on = [aws_vpc.datascientest_vpc]
}

# Créez une route dans la table de routage, pour accéder au public via une passerelle Internet
resource "aws_route" "route_igw" {
  route_table_id         = "${aws_route_table.rtb_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.datascientest_igateway.id}"

  depends_on = [aws_internet_gateway.datascientest_igateway]
}

# Ajouter un sous-réseau public-a à la table de routage
resource "aws_route_table_association" "rta_subnet_association_puba" {
  subnet_id      = "${aws_subnet.public_subnet_a.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"

  depends_on = [aws_route_table.rtb_public]
}

# Ajouter un sous-réseau public-b à la table de routage
resource "aws_route_table_association" "rta_subnet_association_pubb" {
  subnet_id      = "${aws_subnet.public_subnet_b.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"

  depends_on = [aws_route_table.rtb_public]
}

## Créer une passerelle nat pourle sous-réseau public a et une ip élastique
resource "aws_eip" "eip_public_a" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_a" {
  allocation_id = "${aws_eip.eip_public_a.id}"
  subnet_id     = "${aws_subnet.public_subnet_a.id}"

  tags = {
    Name = "datascientest-nat-public-a"
  }
}

## Créer une table de routage pour app un sous-réseau
resource "aws_route_table" "rtb_appa" {

  vpc_id = "${aws_vpc.datascientest_vpc.id}"
  tags = {
    Name        = "datascientest-appa-routetable"
  }

}

#créer une route vers la passerelle nat
resource "aws_route" "route_appa_nat" {
  route_table_id         = "${aws_route_table.rtb_appa.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_a.id}"
}


resource "aws_route_table_association" "rta_subnet_association_appa" {
  subnet_id      = "${aws_subnet.app_subnet_a.id}"
  route_table_id = "${aws_route_table.rtb_appa.id}"
}


## Créer une passerelle Nat et des routes pour le sous-réseau B de l'application et l'ip élastique pour la passerelle b
resource "aws_eip" "eip_public_b" {
  vpc = true
}
resource "aws_nat_gateway" "gw_public_b" {
  allocation_id = "${aws_eip.eip_public_b.id}"
  subnet_id     = "${aws_subnet.public_subnet_b.id}"

  tags = {
    Name = "datascientest-nat-public-b"
  }
}

resource "aws_route_table" "rtb_appb" {

  vpc_id = "${aws_vpc.datascientest_vpc.id}"
  tags = {
    Name        = "datascientest-appb-routetable"
  }

}

resource "aws_route" "route_appb_nat" {
  route_table_id         = "${aws_route_table.rtb_appb.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw_public_b.id}"
}


resource "aws_route_table_association" "rta_subnet_association_appb" {
  subnet_id      = "${aws_subnet.app_subnet_b.id}"
  route_table_id = "${aws_route_table.rtb_appb.id}"
}


resource "aws_lb" "lb_datascientest" {
  name               = "datascientest-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.public_subnet_a.id}", "${aws_subnet.public_subnet_b.id}"]
  security_groups    = [var.sg_application_lb_id]

  enable_deletion_protection = false
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.lb_datascientest.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.datascientest_vms.arn}"
  }
}

resource "aws_lb_target_group" "datascientest_vms" {
  name     = "tf-datascientest-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.datascientest_vpc.id}"
}

## Joindre l' instance A à la zone de disponibilté A au groupe cible
#resource "aws_lb_target_group_attachment" "datascientesta_tg_attachment" {
#  target_group_arn = "${aws_lb_target_group.datascientest_vms.arn}"
#  target_id =   var.datascientest_a_id
#
#  port             = 80
#}

## Joindre l' instance B à la zone de disponibilté B au groupe cible
#resource "aws_lb_target_group_attachment" "datascientestb_tg_attachment" {
#  target_group_arn = "${aws_lb_target_group.datascientest_vms.arn}"
#  target_id =  var.datascientest_b_id
#  port             = 80
#  }

resource "aws_autoscaling_attachment" "server_a_tg_attachment" {
  autoscaling_group_name = var.web_server_a_id
  lb_target_group_arn   = "${aws_lb_target_group.datascientest_vms.arn}"
}

resource "aws_autoscaling_attachment" "server_b_tg_attachment" {
  autoscaling_group_name = var.web_server_b_id
  lb_target_group_arn   = "${aws_lb_target_group.datascientest_vms.arn}"
}