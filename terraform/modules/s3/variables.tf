variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "enable_lifecycle" {
  type        = bool
  default     = true
  description = "Enable lifecycle rules"
}
