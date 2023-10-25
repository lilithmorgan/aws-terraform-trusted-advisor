resource "aws_sns_topic" "trusted_advisor_notifications" {
  name = "trusted-advisor-notifications"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.trusted_advisor_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_event_rule" "trusted_advisor_event_rule" {
  name        = "trusted-advisor-event-rule"
  description = "Capture Trusted Advisor Events"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.trustedadvisor"
  ],
  "detail-type": [
    "Trusted Advisor Check Item Refresh Notification"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns_target" {
  rule      = aws_cloudwatch_event_rule.trusted_advisor_event_rule.name
  target_id = "SNS"
  arn       = aws_sns_topic.trusted_advisor_notifications.arn
}
