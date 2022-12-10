resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_ec2]
  subnets            = var.subnet_ids
  }


resource "aws_lb_target_group" "petclinic" {
  name     = "petclinic"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval = 120
    timeout  = 100
    port     = 8080
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "petclinic" {
  load_balancer_arn = aws_lb.test.id
  port              = "80"
  default_action {
    target_group_arn = aws_lb_target_group.petclinic.id
    type             = "forward"
  }
}