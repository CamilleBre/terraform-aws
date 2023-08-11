#output "public_ip_a" {
#  value = launch_configuration.datascientest_a.public_ip
#  #value = aws_instance.datascientest_a.public_ip
#}

#output "public_ip_b" {
#  value = launch_configuration.datascientest_b.public_ip
#  #value = aws_instance.datascientest_b.public_ip
#}

output "datascientest_a_id" {
  value = aws_launch_configuration.datascientest_a.id
  #value = aws_instance.datascientest_a.id
}

output "datascientest_b_id" {
  value = aws_launch_configuration.datascientest_b.id
  #value = aws_instance.datascientest_a.id
}

output "datascientest_a_name" {
  value = aws_launch_configuration.datascientest_a.name
  #value = aws_instance.datascientest_a.id
}

output "datascientest_b_name" {
  value = aws_launch_configuration.datascientest_b.name
  #value = aws_instance.datascientest_a.id
}