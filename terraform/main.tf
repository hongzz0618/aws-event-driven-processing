terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.6"
    }
  }
}

provider "aws" {
  region = var.region
}

# S3 bucket para uploads (evento origen)
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  enable_lifecycle = true
}

# SNS topic (notificaciones)
module "sns" {
  source     = "./modules/sns"
  topic_name = "file-upload-topic"
  # opcional: suscripción de email
  email_subscription = var.sns_email_subscription
}

# SQS queue (procesamiento async / retries)
module "sqs" {
  source              = "./modules/sqs"
  queue_name          = "file-upload-queue"
  enable_dlq          = true
  max_receive_count   = 5
  visibility_timeout  = 60
  message_retention_s = 345600 # 4 días
}

# Lambda (Node.js) — publica en SNS y SQS
module "lambda" {
  source          = "./modules/lambda"
  function_name   = "fileProcessor"
  sns_topic_arn   = module.sns.topic_arn
  sqs_queue_url   = module.sqs.queue_url
  sqs_queue_arn   = module.sqs.queue_arn
  s3_bucket_arn   = module.s3.bucket_arn
  s3_read_enabled = true
  environment = {
    NODE_OPTIONS  = "--enable-source-maps"
    LOG_LEVEL     = "info"
    SNS_TOPIC_ARN = module.sns.topic_arn
    SQS_QUEUE_URL = module.sqs.queue_url
  }
}

# EventBridge rule (S3 Object Created -> Lambda)
module "eventbridge" {
  source      = "./modules/eventbridge"
  bucket_name = module.s3.bucket_name
  lambda_arn  = module.lambda.lambda_arn
}
