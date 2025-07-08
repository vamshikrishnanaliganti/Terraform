resource "aws_lb_target_group" "frontend_tg" {
  name       = "frontend-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.three-tier-vpc.id

  depends_on = [aws_vpc.three-tier-vpc]

}

resource "aws_lb" "frontend-alb" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  #vpc_id   = aws_vpc.three-tier-vpc.id
  subnets         = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  security_groups = [aws_security_group.alb-frontend-sg.id]
  tags = {
    Name = "frontent-alb"
  }
  depends_on = [aws_lb_target_group.frontend_tg]
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.frontend-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
  depends_on = [aws_lb_target_group.frontend_tg]
}

