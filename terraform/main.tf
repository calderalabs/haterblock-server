provider "aws" {}

data "aws_region" "current" {}

data "aws_ssm_parameter" "dnsimple_account" {
  name = "dnsimple-account"
}

data "aws_ssm_parameter" "dnsimple_token" {
  name = "dnsimple-token"
}

data "aws_ssm_parameter" "slack_webhook" {
  name = "/${var.app_name}/default/slack/incoming-webhooks-url"
}

data "aws_ssm_parameter" "database_password" {
  name = "/${var.app_name}/${terraform.workspace}/database/password"
}

data "aws_ssm_parameter" "domain" {
  name = "/${var.app_name}/${terraform.workspace}/domain"
}

data "aws_ssm_parameter" "subdomain" {
  name = "/${var.app_name}/default/subdomain"
}

provider "dnsimple" {
  token   = "${data.aws_ssm_parameter.dnsimple_token.value}"
  account = "${data.aws_ssm_parameter.dnsimple_account.value}"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "web" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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
    values = ["web"]
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

  tags {
    Name = "haterblock"
  }
}

resource "aws_eip" "web" {
  instance = "${aws_instance.web.id}"
}

resource "dnsimple_record" "a" {
  domain = "${data.aws_ssm_parameter.domain.value}"
  name   = "${data.aws_ssm_parameter.subdomain.value}"
  value  = "${aws_eip.web.public_ip}"
  type   = "A"
}

output "public_ip" {
  value = "${aws_eip.web.public_ip}"
}

# Alarms

module "notify_slack" {
  source = "github.com/calderalabs/terraform-aws-notify-slack?ref=b94670f0914c9714db6bb1141738a4a57ca2ed92"

  sns_topic_name = "slack-topic"

  slack_webhook_url = "${data.aws_ssm_parameter.slack_webhook.value}"
  slack_channel     = "alerts"
  slack_username    = "amazon-reporter"
}

resource "aws_cloudwatch_metric_alarm" "web_cpu" {
  alarm_name          = "Web CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${module.notify_slack.this_slack_topic_arn}"]

  dimensions {
    InstanceId = "${aws_instance.web.id}"
  }
}

# Database

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${data.aws_subnet_ids.default.ids}"]
}

resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "postgres10"
}

resource "aws_security_group" "postgresql" {
  vpc_id = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "postgresql_rds" {
  source                = "github.com/calderalabs/terraform-aws-postgresql-rds?ref=14ccfbe4b72a5ace9990e17317ac930e46421ecc"
  vpc_security_group_id = "${aws_security_group.postgresql.id}"
  engine_version        = "10.3"
  instance_type         = "${var.aws_database_type}"
  database_name         = "${terraform.workspace}"
  database_identifier   = "jl23kj32sdf"
  database_username     = "${var.database_username}"
  database_password     = "${data.aws_ssm_parameter.database_password.value}"
  subnet_group          = "${aws_db_subnet_group.default.name}"
  parameter_group       = "${aws_db_parameter_group.default.name}"
  publicly_accessible   = true

  ok_actions                = ["${module.notify_slack.this_slack_topic_arn}"]
  alarm_actions             = ["${module.notify_slack.this_slack_topic_arn}"]
  insufficient_data_actions = ["${module.notify_slack.this_slack_topic_arn}"]

  project     = "${var.app_name}"
  environment = "${terraform.workspace}"
}

resource "aws_cloudwatch_metric_alarm" "db_connections" {
  alarm_name          = "DB Connections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "This metric monitors rds db connections"
  alarm_actions       = ["${module.notify_slack.this_slack_topic_arn}"]

  dimensions {
    DBInstanceIdentifier = "${module.postgresql_rds.id}"
  }
}

output "database_url" {
  value = "postgresql://${var.database_username}:${data.aws_ssm_parameter.database_password.value}@${module.postgresql_rds.endpoint}/${terraform.workspace}"
}

# Email

resource "aws_iam_user" "mailer" {
  name = "mailer"
}

resource "aws_ses_domain_identity" "default" {
  domain = "${data.aws_ssm_parameter.domain.value}"
}

resource "aws_iam_access_key" "mailer" {
  user = "${aws_iam_user.mailer.name}"
}

resource "aws_iam_user_policy" "mailer" {
  user = "${aws_iam_user.mailer.name}"

  policy = <<EOF
{
  "Statement": [{
    "Effect":"Allow",
    "Action":"ses:SendRawEmail",
    "Resource":"${aws_ses_domain_identity.default.arn}"
  }]
}
EOF
}

resource "aws_ses_domain_dkim" "default" {
  domain = "${aws_ses_domain_identity.default.domain}"
}

resource "dnsimple_record" "dkim" {
  count  = 3
  domain = "${data.aws_ssm_parameter.domain.value}"
  name   = "${element(aws_ses_domain_dkim.default.dkim_tokens, count.index)}._domainkey"
  type   = "CNAME"
  ttl    = 600
  value  = "${element(aws_ses_domain_dkim.default.dkim_tokens, count.index)}.dkim.amazonses.com"
}

resource "dnsimple_record" "ses" {
  domain = "${data.aws_ssm_parameter.domain.value}"
  name   = "_amazonses"
  value  = "${aws_ses_domain_identity.default.verification_token}"
  type   = "TXT"
  ttl    = 600
}

output "smtp_password" {
  value = "${aws_iam_access_key.mailer.ses_smtp_password}"
}

output "smtp_username" {
  value = "${aws_iam_access_key.mailer.id}"
}

output "smtp_server" {
  value = "email-smtp.${data.aws_region.current.name}.amazonaws.com"
}

output "ses_domain_identity_arn" {
  value = "${aws_ses_domain_identity.default.arn}"
}
