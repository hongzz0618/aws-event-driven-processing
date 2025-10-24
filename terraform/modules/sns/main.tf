resource "aws_sns_topic" "this" {
  name = var.topic_name
}

# Suscripción opcional de email
resource "aws_sns_topic_subscription" "email" {
  count     = length(var.email_subscription) > 0 ? 1 : 0
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.email_subscription
}
