# environnement de déploiement
#variable "namespace" {
#  type = string
#}
# VPC
#variable "vpc" {
#  type = any
#}
# paire de clé utilisée
#variable key_name {
#  type = string
#}
# id du groupe de sécurité public
#variable "sg_pub_id" {
#  type = any
#}
# id du groupe de sécurité privée
#variable "sg_priv_id" {
#  type = any
#}


variable "app_subnet_a_id" {
  type = any
}

variable "app_subnet_b_id" {
  type = any
}

variable "sg_id" {
  type = any
}

variable "ec2_key_name" {
  type = any
}