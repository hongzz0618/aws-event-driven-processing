variable "queue_name" {
  type        = string
  description = "SQS queue name"
}

variable "enable_dlq" {
  type        = bool
  default     = true
}

variable "max_receive_count" {
  type        = number
  default     = 5
}

variable "visibility_timeout" {
  type        = number
  default     = 60
}

variable "message_retention_s" {
  type        = number
  default     = 345600 # 4 days
}
