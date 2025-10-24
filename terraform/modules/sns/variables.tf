variable "topic_name" {
  type        = string
  description = "SNS topic name"
}

variable "email_subscription" {
  type        = string
  default     = ""
  description = "Optional email to subscribe"
}
