output "sns_topic_arn" {
  value = aws_sns_topic.trusted_advisor_notifications.arn
  description = "The ARN of the SNS topic for Trusted Advisor notifications."
}
