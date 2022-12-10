resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "rds connection"
    from_port        = 3306
    to_port          = 3306 
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}


# resource "random_password" "root" {
#   length           = 8
#   special          = true
#   override_special = "_"
# }

resource "aws_db_instance" "default" {
  replicate_source_db = "arn:aws:rds:us-east-1:310257323767:db:terraform-20221210160204549100000001"
  # allocated_storage    = 10
  # db_name              = "project"
  # engine               = "mysql"
  # engine_version       = "8.0.31"
  instance_class       = "db.t3.micro"
  # username             = "root"
  # password             = random_password.root.result
  publicly_accessible  = true 
  skip_final_snapshot  = true
  backup_retention_period = 3
  db_subnet_group_name = aws_db_subnet_group.default.id
  vpc_security_group_ids = [aws_security_group.rds.id]
}

# resource "aws_ssm_parameter" "secret" {
#   name        = "/production/database/password/master"
#   description = "The parameter description"
#   type        = "SecureString"
#   value       = random_password.root.result

#   tags = {
#     environment = "production"
#   }
# }

# resource "null_resource" "db_setup" {

#   provisioner "local-exec" {
#     command = "mysql --host=${aws_db_instance.default.address} --port=3306 --user=root --password=${random_password.root.result} < ./module/rds/initial.sql"

#     interpreter = ["bash", "-c"]
#   }

# }