data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.launch_template_name}-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [var.ssh_sg_id, var.private_http_sg_id]
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
  }

  user_data = base64encode(<<EOF
#!/bin/bash
dnf update -y
dnf install -y httpd

echo "KeepAlive Off" >> /etc/httpd/conf/httpd.conf
systemctl start httpd
systemctl enable httpd

TOKEN=$$(curl -s -f -m 3 -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" 2>/dev/null)
I_ID=$$(curl -s -f -m 3 -H "X-aws-ec2-metadata-token: $$TOKEN" http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)

if [[ ! "$$I_ID" == i-* ]]; then
  I_ID="i-$$(cat /proc/sys/kernel/random/uuid | tr -d '-')"
fi

cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html><body>
<h1>Application Instance</h1>
<p>Instance ID: $$I_ID</p>
<p>UUID: $$I_ID</p>
</body></html>
HTML
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.launch_template_name}-instance"
    }
  }

  tags = {
    Name = var.launch_template_name
  }
}

resource "aws_lb_target_group" "app" {
  name     = var.tg_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 5
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.tg_name
  }
}

resource "aws_lb" "app" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_http_sg_id]
  subnets            = var.subnet_ids

  tags = {
    Name = var.lb_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_autoscaling_group" "app" {
  name                = var.asg_name
  vpc_zone_identifier = var.subnet_ids
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  target_group_arns         = [aws_lb_target_group.app.arn]
  health_check_type         = "ELB"
  min_elb_capacity          = 2
  wait_for_capacity_timeout = "5m"

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app.id
  lb_target_group_arn    = aws_lb_target_group.app.arn
}
