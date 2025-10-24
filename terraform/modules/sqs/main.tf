resource "aws_sqs_queue" "dlq" {
  count = var.enable_dlq ? 1 : 0
  name  = "${var.queue_name}-dlq"

  message_retention_seconds = 1209600 # 14 days
}

locals {
  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null
}

resource "aws_sqs_queue" "this" {
  name = var.queue_name

  visibility_timeout_seconds = var.visibility_timeout
  message_retention_seconds  = var.message_retention_s
  redrive_policy             = local.redrive_policy
}
