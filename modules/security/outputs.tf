output "sg_id" {
    value = aws_security_group.sg_datascientest.id
}

output "sg22_id" {
    value = aws_security_group.sg_22.id
}

output "ec2_key_name" {
    value = aws_key_pair.myec2key.key_name
}

output "sg_application_lb_id" {
    value = aws_security_group.sg_application_lb.id
}

output "sg_rds" {
    value = aws_security_group.rds
}

