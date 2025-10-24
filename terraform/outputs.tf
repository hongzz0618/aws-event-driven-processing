output "bucket_name" {
  value = module.s3.bucket_name
}

output "bucket_arn" {
  value = module.s3.bucket_arn
}

output "lambda_name" {
  value = module.lambda.lambda_name
}

output "lambda_arn" {
  value = module.lambda.lambda_arn
}

output "sns_topic_arn" {
  value = module.sns.topic_arn
}

output "sqs_queue_url" {
  value = module.sqs.queue_url
}

output "sqs_queue_arn" {
  value = module.sqs.queue_arn
}
