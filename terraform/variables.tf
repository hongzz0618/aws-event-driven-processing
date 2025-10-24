variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
  default     = "event-driven-bucket-demo-1234"
}

variable "sns_email_subscription" {
  description = "Optional email to subscribe to SNS topic"
  type        = string
  default     = ""
}
