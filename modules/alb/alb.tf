locals {
  role       = var.role
  client     = var.short_client
  dns_prefix = var.dns_prefix
  env        = var.env
}

resource "aws_lb_target_group" "this" {
  name        = "${local.client}-${local.env}-TG"
  port        = 8443
  target_type = "instance"
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/jbilling/login/auth"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 30
    interval            = 50
    matcher             = "200"
    protocol            = "HTTPS"
  }
  stickiness {
    enabled = true
    type    = "lb_cookie"
  }
  tags = merge(
    var.tags,
    tomap({ "Name" = "${local.client}-${local.env}-tg"
    })
    , {
      git_commit           = "052ad3ac2e9ee12416613febf92b9393b74fb6b0"
      git_file             = "modules/alb/alb.tf"
      git_last_modified_at = "2023-05-26 08:12:26"
      git_last_modified_by = "dmytro@itsyndicate.org"
      git_modifiers        = "dmytro"
      git_org              = "dmytro-its"
      git_repo             = "lecture-infracost"
      yor_name             = "this"
      yor_trace            = "3cb9b8e0-ab28-41c9-961f-6b22543bc188"
  })
}

#### import iinstances

data "aws_instances" "all" {
  instance_tags = {
    Role = "app"
  }
  filter {
    name   = "instance.group-id"
    values = var.instance_group_id
  }
}

data "aws_subnets" "all" {
  tags = {
    "Role" = "public"
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
resource "aws_alb_target_group_attachment" "tgattachment" {
  count = length(data.aws_instances.all.ids)
  ###count = length(data.aws_instances.fc.ids)
  #count            = length(aws_instance.app.*.id)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = element(data.aws_instances.all.ids, count.index)
  ###target_id        = element(data.aws_instances.fc.ids, count.index)
  #target_id = data.aws_instances.all.ids
}

resource "aws_lb" "this" {
  name               = "${local.client}-${local.env}-${local.role}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  #subnets = element(data.aws_subnets.all.ids, 2)
  #subnets = [ data.aws_subnets.all.ids ]
  subnets = [for id in data.aws_subnets.all.ids : id]
  ###subnets = [for id in data.aws_subnets.fc.ids : id]
  tags = {
    git_commit           = "cd9cf36061b2576cf99007215aa13f575888e2de"
    git_file             = "modules/alb/alb.tf"
    git_last_modified_at = "2023-05-25 09:08:21"
    git_last_modified_by = "dmytro@itsyndicate.org"
    git_modifiers        = "dmytro"
    git_org              = "dmytro-its"
    git_repo             = "lecture-infracost"
    yor_name             = "this"
    yor_trace            = "8d6f19dd-c0bf-48d6-a9fe-fb7438098d4b"
  }
}

resource "aws_lb_listener" "front_http" {
  count             = var.enable_http_listener ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = merge(
    var.tags,
    tomap({ "Name" = "${local.client}-${local.env}-alb"
    })
  )
}

resource "aws_lb_listener" "front_https" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

#data "aws_route53_zone" "main" {
#  zone_id = "ZEHQM7JHS0Y08"
#  name = var.dns-name
#}

/*resource "aws_route53_record" "this" {
  zone_id  = data.aws_route53_zone.main.zone_id
#  name     = join(".", ["${local.client}-${local.env}-22", data.aws_route53_zone.main.name])
  name     = join(".", ["${local.dns_prefix}", var.dns-name])
  type     = "A"
  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}
*/
############################################
#### import fullcreative instances

/* data "aws_instances" "fc" {
  instance_tags = {
    Role =  "app"
  }
  filter {
    name   = "instance.group-id"
    values = ["sg-09cadbaeaf858004b"]
  }
}


data "aws_subnets" "fc" {
  tags = {
    "Role" = "public"
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
} */


#### Add listener rules if not already present

/* resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.front_https.arn
  priority     = var.priority

  action {
    type             = "redirect"
    target_paths = length(var.target_paths) == 1 ? var.target_groups[0].arn : null

    dynamic "forward" {
      for_each = length(var.target_groups) > 1 ? [1] : []
      content {
        dynamic "target_group" {
          for_each = var.target_groups
          content {
            arn    = target_group.value.arn
            weight = target_group.value.weight
          }
        }
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.path_pattern) > 0 ? [1] : []
    content {
      path_pattern {
        values = var.path_pattern
      }
    }
  }
} */
