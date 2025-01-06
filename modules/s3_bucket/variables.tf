variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "expiration_days" {
  description = "Number of days before backups expire"
  type        = number
  default     = 30
}

variable "repository_version" {
  description = "The commit hash or version tag to include in the S3 object key"
  type        = string
}