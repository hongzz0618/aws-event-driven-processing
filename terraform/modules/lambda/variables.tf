variable "function_name" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "sqs_queue_url" {
  type = string
}

variable "sqs_queue_arn" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "s3_read_enabled" {
  type    = bool
  default = false
}

variable "environment" {
  type    = map(string)
  default = {}
}
