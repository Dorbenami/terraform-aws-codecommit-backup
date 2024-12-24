variable "pipeline_name" {
  description = "Name of the pipeline"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the pipeline"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket for backups"
  type        = string
}

variable "repository_name" {
  description = "Name of the CodeCommit repository"
  type        = string
}

variable "branch_name" {
  description = "Branch name for the CodeCommit repository"
  type        = string
  default     = "main"
}
