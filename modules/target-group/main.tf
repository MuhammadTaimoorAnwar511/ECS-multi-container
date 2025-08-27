# modules/target-group/main.tf
resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  protocol_version = "HTTP1"
  ip_address_type  = "ipv4"

  health_check {
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 50
    interval            = 60
    matcher             = "200"
  }

  tags = merge(
    {
      Name = var.target_group_name
    },
    var.tags
  )
}
