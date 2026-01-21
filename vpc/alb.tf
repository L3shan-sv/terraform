module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name               = "demo-alb"
  load_balancer_type = "application"
  vpc_id             = aws_vpc.demo-vpc.id

  subnets = [
    aws_subnet.public-subnet-1.id,
    aws_subnet.public-subnet-2.id
  ]

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      default_action = [
        {
          type             = "forward"
          target_group_key = "web"
        }
      ]
    }
  }

  target_groups = {
    web = {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "ip"

      # IMPORTANT: EKS / Ingress will attach targets dynamically
      create_attachment = false
    }
  }
}