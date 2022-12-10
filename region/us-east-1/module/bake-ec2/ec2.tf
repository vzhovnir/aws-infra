resource "aws_security_group" "ec2" {
  name        = "ec2"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "rds connection"
    from_port        = 22
    to_port          = 22 
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "rds connection"
    from_port        = 8080
    to_port          = 8080 
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "rds connection"
    from_port        = 80
    to_port          = 80 
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
resource "aws_instance" "ec2_instance" {
    ami = "ami-08c40ec9ead489470"
    subnet_id = var.subnet_id
    instance_type = "t2.micro"
    key_name =  "project-ec2"
    associate_public_ip_address = true
    security_groups = [aws_security_group.ec2.id]
    user_data = <<EOF
#!/bin/bash
    sudo su
    apt-get update -y
    apt-get install mc git maven -y
    git clone https://github.com/spring-projects/spring-petclinic.git
    sudo echo "# database init, supports mysql too
    database=mysql
    spring.datasource.url=jdbc:mysql://${var.database_endpoint}/petclinic
    spring.datasource.username=petclinic-dev
    spring.datasource.password=petclinic
    # SQL is written to be idempotent so this is safe
    spring.sql.init.mode=always" > /spring-petclinic/src/main/resources/application-mysql.properties
    cd spring-petclinic
    sudo mvn spring-boot:run -Dspring-boot.run.profiles=mysql
EOF
}
