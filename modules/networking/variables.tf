variable "cidr_vpc" {
  description = "CIDR du VPC"
  default     = "10.1.0.0/16"

}



variable "cidr_public_subnet_a" {
  description = "CIDR du Sous-réseau  public a"
  default     = "10.1.0.0/24"

}

variable "cidr_public_subnet_b" {
  description = "CIDR du Sous-réseau  public b"
  default     = "10.1.1.0/24"

}

variable "cidr_app_subnet_a" {
  description = "CIDR du Sous-réseau privé a"
  default     = "10.1.2.0/24"

}

variable "cidr_app_subnet_b" {
  description = "CIDR du Sous-réseau privé b"
  default     = "10.1.3.0/24"

}



variable "az_a" {
  description = "zone de disponibilité a"
  default     = "eu-west-3a"
}


variable "az_b" {
  description = "zone de disponibilité b"
  default     = "eu-west-3b"

}

variable "sg_application_lb_id" {
  type = any
}

variable "datascientest_a_id"{
  type = any
}

variable "datascientest_b_id"{
  type = any
}

variable "web_server_a_id"{
  type = any
}

variable "web_server_b_id"{
  type = any
}