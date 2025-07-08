resource "aws_lb_target_group" "backend_tg" {
  name       = "backend-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.three-tier-vpc.id
  
  depends_on = [aws_vpc.three-tier-vpc]

}

resource "aws_lb" "backend-alb" {
  name               = "backend-alb"
  internal           = true
  load_balancer_type = "application"
  #vpc_id   = aws_vpc.three-tier-vpc.id
  # subnets         = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  subnets            = [aws_subnet.backend_subnet1.id, aws_subnet.backend_subnet2.id]
  security_groups = [aws_security_group.alb-backend-sg.id]
  tags = {
    Name = "backend-alb"
  }
  depends_on = [aws_lb_target_group.backend_tg]
}


resource "aws_lb_listener" "backend_end" {
  load_balancer_arn = aws_lb.backend-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
  depends_on = [aws_lb_target_group.backend_tg]
}


# vpc
# internet gateway
# natgateway
# 2 pub subnets 6 private subnets
# pub RT
# pri RT
# sg
# key
# #----------------------rds and route53------------------
# rds-subnet_group
# rds-mysqldb
# replica
# route53
# certificate manager
# #----------------------alb and route53----------------------
# f-tg
# f-alb
# b-tg
# b-alb
# ec2-frontend and backend temporary todo required setup
# ami
# launch template
# autoscalling
# route53
# cloudfront
# aws waf( web application firewall)
