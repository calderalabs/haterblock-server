provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_key}"
}

provider "dnsimple" {
  token   = "${var.dnsimple_token}"
  account = "${var.dnsimple_account}"
}

resource "aws_security_group" "web" {
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "web" {
  public_key = "${file(var.ssh_public_key_file)}"
}

data "aws_ami" "web" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:Name"
    values = ["${var.app_name}"]
  }
}

resource "aws_instance" "web" {
  ami             = "${data.aws_ami.web.id}"
  instance_type   = "${var.aws_instance_type}"
  key_name        = "${aws_key_pair.web.key_name}"
  security_groups = ["${aws_security_group.web.name}"]

  lifecycle {
    ignore_changes = ["ami"]
  }
}

resource "aws_eip" "web" {
  instance = "${aws_instance.web.id}"
}

resource "dnsimple_record" "a" {
  domain = "${var.domain}"
  name   = "api"
  value  = "${aws_eip.web.public_ip}"
  type   = "A"
}

output "public_ip" {
  value = "${aws_eip.web.public_ip}"
}

# Alarms

data "aws_ssm_parameter" "slack_webhook" {
  name = "/haterblock-server/slack/incoming-webhooks/url"
}

module "notify_slack" {
  source = "terraform-aws-modules/notify-slack/aws"

  sns_topic_name = "slack-topic"

  slack_webhook_url = "${slack_webhook.value}"
  slack_channel     = "aws-notification"
  slack_username    = "reporter"
}

resource "aws_cloudwatch_metric_alarm" "web_cpu" {
  alarm_name          = "Web CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${module.notify_slack.this_slack_topic_arn}"]

  dimensions {
    InstanceId = "${aws_instance.web.id}"
  }
}
