# Create an AWS DB instance resource that requires secrets

resource "aws_db_instance" "wordpressdb" {
 depends_on = [var.sg_rds]
 allocated_storage    = 10
 db_name              = "mydb"
 engine               = "mysql"
 engine_version       = "5.7"
 instance_class       = "db.t3.micro"
 username             = var.username
 password             = var.password
 skip_final_snapshot  = true
 vpc_security_group_ids= [var.sg_rds.id]
}