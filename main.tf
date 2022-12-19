resource "aws_launch_configuration" "web" {
    name_prefix = "web-"
  image_id = "${lookup(var.AMIS, var.AWS_Region)}" #red hat linux 9 image
  instance_type = var.aws_instancetype
  key_name = "mykey"

  security_groups = ["${aws_security_group.allow_http.id}"]
  associate_public_ip_address = false 
  

  user_data = <<USER_DATA
  #!/bin/bash
  sudo dnf install httpd
    USER_DATA

lifecycle {
  create_before_destroy = true
}
}

resource "aws_lb" "app_lb" {
    name = "App-lb"
    load_balancer_type = "application"
    security_groups = [
        "${aws_security_group.allow_http.id}"
    ]
  subnets = [
    "${aws_subnet.private_sub3.id}",
    "${aws_subnet.private_sub4.id}"
  ]

  enable_deletion_protection = false
}


resource "aws_lb_target_group" "albtg" {
  name        = "App-lb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.coalfire_VPC.id 
}

resource "aws_lb_listener" "alblistener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.albtg.arn
  }
}