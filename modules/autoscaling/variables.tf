variable "min_instances" {
  description = "Minimum number of instances in the autoscaling group"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of instances in the autoscaling group"
  type        = number
}

variable "public_subnet_a_id" {
  type = any 
}

variable "public_subnet_b_id" {
  type = any 
}

variable "datascientest_a_name" {
  type = any 
}

variable "datascientest_b_name" {
  type = any 
}