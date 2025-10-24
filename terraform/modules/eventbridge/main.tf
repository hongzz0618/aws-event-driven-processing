resource "aws_cloudwatch_event_rule" "s3_object_created" {
  name        = "s3-object-created-${var.bucket_name}"
  description = "Trigger Lambda on S3 Object Created for bucket ${var.bucket_name}"

  event_pattern = jsonencode({
    "source": ["aws.s3"],
    "detail-type": ["Object Created"],
    "detail": {
      "bucket": {
        "name": [var.bucket_name]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.s3_object_created.name
  target_id = "lambda"
  arn       = var.lambda_arn
}

# Permiso para que EventBridge invoque la Lambda
resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_object_created.arn
}
