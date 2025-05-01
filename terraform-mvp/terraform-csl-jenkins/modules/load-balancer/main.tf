resource "aws_lb" "project_lb" {
  name               = var.lb_name
  internal           = var.is_external
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_enable_ssh_https]
  subnets            = var.subnet_ids # Replace with your subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "project-lb"
  }
}

resource "aws_lb_target_group_attachment" "project_lb_target_group_attachment" {
  target_group_arn = var.lb_target_group_arn
  target_id        = var.ec2_instance_id # Replace with your EC2 instance reference
  port             = var.lb_target_group_attachment_port
}

resource "aws_lb_listener" "project_lb_listner" {
  load_balancer_arn = aws_lb.project_lb.arn
  port              = var.lb_listner_port
  protocol          = var.lb_listner_protocol

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}

# https listner on port 443
resource "aws_lb_listener" "project_lb_https_listner" {
  load_balancer_arn = aws_lb.project_lb.arn
  port              = var.lb_https_listner_port
  protocol          = var.lb_https_listner_protocol
  # ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08" 
  #ssl_policy        = "ELBSecurityPolicy-TLS13-1-3-2021-06"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.project_acm_arn

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}